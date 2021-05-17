#include <algorithm> 
#include <mitsuba/core/properties.h>
#include <mitsuba/core/fstream.h>
#include <mitsuba/core/fresolver.h>
#include <mitsuba/core/frame.h>
#include <mitsuba/render/sampler.h>
// #include <mitsuba/render/texture.h>
// #include <mitsuba/render/bsdf.h>
#include <mitsuba/render/phase.h>
// #include <mitsuba/hw/basicshader.h>
#include <mitsuba/render/medium.h>
// #include <mitsuba/core/warp.h>

MTS_NAMESPACE_BEGIN

class TabulatedPhaseFunction : public PhaseFunction {
public:
    TabulatedPhaseFunction(const Properties &props) : PhaseFunction(props) {
    	std::string filename = props.getString("filename");

    	m_filename = filename;
    	m_filename.append(".bin");

    	m_filename_cdf = filename;
    	m_filename_cdf.append("_cdf.bin");

    	m_filename_density = filename;
    	m_filename_density.append("_density.bin");

		m_num_theta_i = 91;
		m_num_phi_i = 1;

		m_num_theta_o = 181;
		m_num_phi_o = 361;

		m_num_slice = m_num_theta_o * m_num_phi_o;
		m_size_phase = m_num_theta_i * m_num_phi_i * m_num_slice;

        loadPhaseFunction();
        loadCDF();
        loadDensity();
        // Point2 sample = Point2(0.23f, 0.56f);
        // bool is_mirror_wi;
        // sampleCDF_test(sample, is_mirror_wi);
    }

    TabulatedPhaseFunction(Stream *stream, InstanceManager *manager) : PhaseFunction(stream, manager) {
        m_filename = stream->readString();
        loadPhaseFunction();
        loadCDF();
        loadDensity();
        configure();
    }

    // virtual ~TabulatedPhaseFunction() { }

    void serialize(Stream *stream, InstanceManager *manager) const {
        PhaseFunction::serialize(stream, manager);
    }

    void configure() {
        PhaseFunction::configure();
        m_type = EAnisotropic | ENonSymmetric;
    }    

	void loadPhaseFunction() {
		fs::path resolved = Thread::getThread()->getFileResolver()->resolve(m_filename);
		Log(EInfo, "Loading pdf \"%s\"", m_filename.c_str());
		ref<FileStream> stream = new FileStream(resolved, FileStream::EReadOnly);
		stream->setByteOrder(Stream::ELittleEndian);
		
		m_phase_function.reserve(m_size_phase);
		float *v = (float *) malloc(m_size_phase * sizeof(float));
		stream->readSingleArray(v, m_size_phase);
		m_phase_function.assign(v, v + m_size_phase);
		stream->close();
		free(v);
		// printf("N of Phase function: %I64u\n", m_phase_function.size());
		// for (int i = 0; i < 10; i++) {		
		// 	printf("%f\t", m_phase_function[i]);
		// }
		// printf("\n");
	}

	void loadCDF() {
		fs::path resolved = Thread::getThread()->getFileResolver()->resolve(m_filename_cdf);
		Log(EInfo, "Loading cdf \"%s\"", m_filename_cdf.c_str());
		ref<FileStream> stream = new FileStream(resolved, FileStream::EReadOnly);
		stream->setByteOrder(Stream::ELittleEndian);
		
		m_cdf.reserve(m_size_phase);
		float *v = (float *) malloc(m_size_phase * sizeof(float));
		stream->readSingleArray(v, m_size_phase);
		m_cdf.assign(v, v + m_size_phase);
		stream->close();
		free(v);
		// printf("N of CDF: %I64u\n", m_cdf.size());
		// for (int i = 0; i < 10; i++) {		
		// 	printf("%f\t", m_cdf[i]);
		// }
		// printf("\n");
	}

	void loadDensity() {
		fs::path resolved = Thread::getThread()->getFileResolver()->resolve(m_filename_density);
		Log(EInfo, "Loading density \"%s\"", m_filename_density.c_str());
		ref<FileStream> stream = new FileStream(resolved, FileStream::EReadOnly);
		stream->setByteOrder(Stream::ELittleEndian);
		
		m_density.reserve(m_num_theta_i);
		float *v = (float *) malloc(m_num_theta_i * sizeof(float));
		stream->readSingleArray(v, m_num_theta_i);
		m_density.assign(v, v + m_num_theta_i);
		stream->close();
		free(v);
		// printf("N of density: %I64u\n", m_density.size());
		// for (int i = 0; i < 10; i++) {		
		// 	printf("%f\t", m_density[i]);
		// }
		// printf("\n");
	}


	void findWi(const PhaseFunctionSamplingRecord &pRec, Float& phi_i, Float& theta_i, bool& is_mirror) const {
		Vector wi = normalize(Frame(pRec.mRec.orientation).toLocal(pRec.wi)); 

		// z is in (1,-1) ---mapping--> theta_i is in (0,180)
		// [y,x] is in ([0,1]...[1,0]...[0,-1]...[-1,0]...[0,1]) 
		// ---mapping--> phi_i is in (0,90,180,270,360) 
		phi_i = radToDeg(atan2(wi.y, wi.x));
		if (phi_i < 0) phi_i = phi_i + 360;

		theta_i = radToDeg(acos(wi.z));
		is_mirror = ( theta_i > 90.f );
		if (is_mirror) theta_i = 180.f - theta_i;
	}

	void findWo(const PhaseFunctionSamplingRecord &pRec, const Float& phi_i, const Float& theta_i, const bool& is_mirror, Float& phi_o, Float& theta_o) const {		
		Vector wo = normalize(Frame(pRec.mRec.orientation).toLocal(pRec.wo)); 

		if (is_mirror) wo.z = -wo.z;
		// Convert wo to space of phase function table 
		// rotate wo along z-axis with -rotate_phi
		// then rotate wo along y-axis with -rotate_theta
		Matrix4x4 rotationMatrix_phi = mitsuba::Transform::rotate(Vector(0.0f,0.0f,1.0f), -phi_i).getMatrix();
		Matrix4x4 rotationMatrix_theta = mitsuba::Transform::rotate(Vector(0.0f,1.0f,0.0f), -theta_i).getMatrix();
		Vector4 _wo = rotationMatrix_theta * (rotationMatrix_phi * Vector4(wo.x, wo.y, wo.z, 1.0f));
		wo = Vector(_wo.y, _wo.x, -_wo.z); // Revert z, and switch x and y
		
		phi_o = radToDeg(atan2(wo.y, wo.x));
		if (phi_o < 0) phi_o = phi_o + 360;

		theta_o = radToDeg(acos(wo.z));
		// if (phi_o < 0)
		// {
		// 	std::cout << "phi_o:" << phi_o << std::endl;		
		// 	std::cout << "theta_o:" << theta_o << std::endl;		
		// 	std::cout << "wo:" << wo.toString() << std::endl;		
		// }
	}

	void findWo_inv(PhaseFunctionSamplingRecord &pRec, const Float& phi_i, const Float& theta_i, const bool& is_mirror, const Float& phi_o, const Float& theta_o) const {		
		Vector wo = Vector(sin(degToRad(theta_o))*cos(degToRad(phi_o)), sin(degToRad(theta_o))*sin(degToRad(phi_o)), cos(degToRad(theta_o)));
		Matrix4x4 rotationMatrix_phi = mitsuba::Transform::rotate(Vector(0.0f,0.0f,1.0f), phi_i).getMatrix();
		Matrix4x4 rotationMatrix_theta = mitsuba::Transform::rotate(Vector(0.0f,1.0f,0.0f), theta_i).getMatrix();
		Vector4 _wo = rotationMatrix_phi * (rotationMatrix_theta * Vector4(wo.y, wo.x, -wo.z, 1.0f));
		wo = Vector(_wo.x, _wo.y, _wo.z);
		if (is_mirror) wo.z = -wo.z;

		pRec.wo = normalize(Frame(pRec.mRec.orientation).toWorld(wo)); 
	}

    Float eval(const PhaseFunctionSamplingRecord &pRec) const {
		Float phi_i, theta_i, phi_o, theta_o;
		bool is_mirror;

		findWi(pRec, phi_i, theta_i, is_mirror);
		findWo(pRec, phi_i, theta_i, is_mirror, phi_o, theta_o);

		// phi_i is always 0 in our case
		// theta_i is in (0,90)
		// phi_o is in (0,360)
		// theta_o is in (0,180)
		int index = int(theta_i) * m_num_slice + int(phi_o) * m_num_theta_o + int(theta_o);
		// if (index < 0 || index > (m_phase_function.size()-1))
		// {
		// 	std::cout << "theta_i:" << theta_i << std::endl;	
		// 	std::cout << "phi_i:" << phi_i << std::endl;	
		// 	std::cout << "theta_o:" << theta_o << std::endl;	
		// 	std::cout << "phi_o:" << phi_o << std::endl;	
		// 	std::cout << "pRec.wi:" << pRec.wi.toString() << std::endl;	
		// 	std::cout << "pRec.wo:" << pRec.wo.toString() << std::endl;	
		// 	std::cout << "GYGYGYGYGYGYGYGYG" << std::endl;
		// }
		return m_phase_function[index];
    }

    Float sample(PhaseFunctionSamplingRecord &pRec, Float &pdf, Sampler *sampler) const {
    	// std::cout << "pRec.wi:" << pRec.wi.toString() << std::endl;
    	Point2 sample(sampler->next2D());
		Float phi_i, theta_i;
		bool is_mirror;

		findWi(pRec, phi_i, theta_i, is_mirror);
		int index = int(theta_i) * m_num_slice;
		// if (index < 0 || index > (m_cdf.size()-1))
		// 	std::cout << "GGGGGGGGGGGGGGGGGGGGG" << std::endl;

		std::vector<Float> vs(&m_cdf[index], &m_cdf[index] + m_num_slice);
		auto lo = std::lower_bound(vs.begin(), vs.end(), sample[0]) - vs.begin();
		auto up = lo + 1;

		Float a = sample[0]-vs[lo];
		Float b = vs[up]-vs[lo];
		Float theta_diff = b > 0.0f? a/b : a ;
		Float theta_o = (lo % m_num_theta_o) + theta_diff;
		Float phi_o = (int)(lo / m_num_theta_o) + sample[1];

		findWo_inv(pRec, phi_i, theta_i, is_mirror, phi_o, theta_o);

		// if ((index + lo) < 0 || (index + lo) > (m_phase_function.size()-1))
		// 	std::cout << "YYYYYYYYYYYYYYYYYYYYYY" << std::endl;
		pdf = m_phase_function[index + lo];
		// std::cout << "pRec.wo:" << pRec.wo.toString() << std::endl;
    	// std::cout << "pdf:" << pdf << std::endl;
    	
		return 1.0f;
	}

    Float sample(PhaseFunctionSamplingRecord &pRec, Sampler *sampler) const {
    	Float pdf;
        TabulatedPhaseFunction::sample(pRec, pdf, sampler);
        return 1.0f;
    }

	bool needsDirectionallyVaryingCoefficients() const { return true; }

    Float sigmaDir(Float cosTheta) const {
    	Float theta_i = radToDeg(acos(cosTheta));
    	if (theta_i > 90) theta_i = 180 - theta_i;
 		return m_density[int(theta_i)];   	
    }


    std::string toString() const {
        std::ostringstream oss;
        oss << "TabulatedPhaseFunction[size=" << m_phase_function.size() << "]";
        return oss.str();
    }

    MTS_DECLARE_CLASS()

private:
    std::string m_filename, m_filename_cdf, m_filename_density;
    int m_num_theta_i, m_num_phi_i, m_num_theta_o, m_num_phi_o;
    int m_num_slice, m_size_phase;
    std::vector<Float> m_phase_function, m_cdf, m_density;
};

MTS_IMPLEMENT_CLASS_S(TabulatedPhaseFunction, false, PhaseFunction)
MTS_EXPORT_PLUGIN(TabulatedPhaseFunction, "Tabulated phase function 4d");
MTS_NAMESPACE_END