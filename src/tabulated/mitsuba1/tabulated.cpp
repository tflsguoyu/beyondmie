#include <mitsuba/render/phase.h>
#include <mitsuba/render/sampler.h>
#include <mitsuba/core/properties.h>
#include <mitsuba/core/frame.h>
#include <mitsuba/core/pmf.h>

MTS_NAMESPACE_BEGIN


class SimpleTabulatedPhaseFunction : public PhaseFunction {
public:
    SimpleTabulatedPhaseFunction(const Properties &props) : PhaseFunction(props) {
        bool valid = false;
        if(props.hasProperty("filename")) {
            printf("Tabulated Phase loaded from file\n");
            m_filename = props.getString("filename");
            m_primIndex = props.getInteger("index", 0);
            valid = true;
        } else {
            m_filename.clear();
            if(props.hasProperty("phaseString")) {
                std::vector<std::string> phase = tokenize(props.getString("phaseString"), " ,;");
                char *end_ptr = NULL;
                for (size_t i=0; i<phase.size(); ++i) {
                    Float val = (Float) strtod(phase[i].c_str(), &end_ptr);
                    if (*end_ptr != '\0') SLog(EError, "Could not parse the phase value!");
                    m_distrb.append(val);
                }
                valid = true;
            }
        }
        Assert(valid);
    }

    SimpleTabulatedPhaseFunction(Stream *stream, InstanceManager *manager) : PhaseFunction(stream, manager) {
        m_filename = stream->readString();
        configure();
    }

    virtual ~SimpleTabulatedPhaseFunction() { }

    void serialize(Stream *stream, InstanceManager *manager) const {
        PhaseFunction::serialize(stream, manager);
        stream->writeString(m_filename);
    }

    void configure() {
        PhaseFunction::configure();
        m_type = EAngleDependence;

        // Load from file
        FILE *fin = fopen(m_filename.c_str(),"rb");
        if(!m_filename.empty()) {
            int numBins;
            fread(&numBins, sizeof(int), 1, fin);
            for(int i = 0; i < numBins; i++) {
                Float val;
                fread(&val, sizeof(Float), 1, fin);
                m_distrb.append(val);
            }
            fclose(fin);
            printf("Tabulate of size %zu loaded from file...\n", m_distrb.size());
        }
        m_distrb.normalize();
        std::cout << "Configured!" << std::endl;
    }

    inline Float sample(PhaseFunctionSamplingRecord &pRec, Sampler *sampler) const {
        Point2 sample(sampler->next2D());
        size_t i = m_distrb.sampleReuse(sample.x);
        Float cosTheta = ((static_cast<Float>(i) + sample.x)/m_distrb.size() - 0.5f)*2.0f;
        Float sinTheta = math::safe_sqrt(1.0f - cosTheta*cosTheta), sinPhi, cosPhi;

        math::sincos(2*M_PI*sample.y, &sinPhi, &cosPhi);
        pRec.wo = Frame(-pRec.wi).toWorld(Vector(
            sinTheta * cosPhi,
            sinTheta * sinPhi,
            cosTheta
        ));
        return 1.0f;
    }

    Float sample(PhaseFunctionSamplingRecord &pRec, Float &pdf, Sampler *sampler) const {
        SimpleTabulatedPhaseFunction::sample(pRec, sampler);
        pdf = SimpleTabulatedPhaseFunction::eval(pRec);
        return 1.0f;
    }

    Float eval(const PhaseFunctionSamplingRecord &pRec) const {
        int i = static_cast<int>(0.5f*(dot(-pRec.wi, pRec.wo) + 1.0f)*static_cast<Float>(m_distrb.size()));
        i = math::clamp(i, 0, static_cast<int>(m_distrb.size()) - 1);
        return INV_FOURPI*m_distrb[i]*static_cast<Float>(m_distrb.size());
    }

    Float getMeanCosine() const {
        Log(EError, "Not implemented!");
        return 0.0f;
    }

    std::string toString() const {
        std::ostringstream oss;
        oss << "SimpleTabulatedPhaseFunction[size=" << m_distrb.size() << "]";
        return oss.str();
    }

    MTS_DECLARE_CLASS()

private:
    std::string m_filename;
    int m_primIndex;
    DiscreteDistribution m_distrb;
};

MTS_IMPLEMENT_CLASS_S(SimpleTabulatedPhaseFunction, false, PhaseFunction)
MTS_EXPORT_PLUGIN(SimpleTabulatedPhaseFunction, "Tabulated phase function");
MTS_NAMESPACE_END
