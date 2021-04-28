#include <mitsuba/core/properties.h>
#include <mitsuba/render/phase.h>
#include <mitsuba/core/distr_1d.h>

NAMESPACE_BEGIN(mitsuba)

template <typename Float, typename Spectrum>
class SimpleTabulatedPhaseFunction final
    : public PhaseFunction<Float, Spectrum> {
public:
    MTS_IMPORT_BASE(PhaseFunction, m_flags)
    MTS_IMPORT_TYPES(PhaseFunctionContext)
    using Index = uint32_array_t<Float>;

    SimpleTabulatedPhaseFunction(const Properties &props) : Base(props) {
        if (props.has_property("filename")) {
            m_filename = props.string("filename");
            printf("Loading tabulated Phase function from file %s\n", m_filename.c_str());
        }
        m_flags = +PhaseFunctionFlags::Anisotropic;
        // Load from file
        FILE *fin = fopen(m_filename.c_str(), "rb");
        int num_bins;
        fread(&num_bins, sizeof(int), 1, fin);
        std::vector<ScalarFloat> table(num_bins);
        for (int i = 0; i < num_bins; i++) {
            ScalarFloat val;
            fread(&val, sizeof(ScalarFloat), 1, fin);
            table[i] = val;
        }
        fclose(fin);
        m_distrb = DiscreteDistribution<Float>(table.data(), num_bins);
        printf("Finish loading, the size is %zu.\n", m_distrb.size());        
    }

    MTS_INLINE Float eval_tab(Float cos_theta) const {
        Index i = static_cast<Index>(0.5f * (cos_theta + 1.0f) * static_cast<ScalarFloat>(m_distrb.size()));
        i = enoki::clamp(i, 0, static_cast<Index>(m_distrb.size()) - 1);
        return math::InvFourPi<Float> * m_distrb.eval_pmf_normalized(i) * static_cast<Float>(m_distrb.size());
    }

    std::pair<Vector3f, Float> sample(const PhaseFunctionContext & /* ctx */,
                                      const MediumInteraction3f &mi,
                                      const Point2f &sample,
                                      Mask active) const override {
        MTS_MASKED_FUNCTION(ProfilerPhase::PhaseFunctionSample, active);

        Index i;
        Float sample_x;
        std::tie(i, sample_x) = m_distrb.sample_reuse(sample.x());
        Float cos_theta = ((static_cast<Float>(i) + sample_x) / m_distrb.size() - 0.5f) * 2.0f;
        Float sin_theta = enoki::safe_sqrt(1.0f - cos_theta * cos_theta);

        auto [sin_phi, cos_phi] = enoki::sincos(2 * math::Pi<ScalarFloat> * sample.y());
        auto wo = Vector3f(sin_theta * cos_phi, sin_theta * sin_phi, cos_theta);
        wo = mi.to_world(wo);
        Float pdf = eval_tab(dot(wo, -mi.wi));
        return std::make_pair(wo, pdf);
    }

    Float eval(const PhaseFunctionContext & /* ctx */,
               const MediumInteraction3f &mi, const Vector3f &wo,
               Mask active) const override {
        MTS_MASKED_FUNCTION(ProfilerPhase::PhaseFunctionEvaluate, active);

        return eval_tab(dot(wo, -mi.wi));
    }

    std::string to_string() const override {
        std::ostringstream oss;
        oss << "SimpleTabulatedPhaseFunction[size=" << m_distrb.size() << "]";
        return oss.str();
    }

    MTS_DECLARE_CLASS()

private:
    std::string m_filename;
    DiscreteDistribution<Float> m_distrb;
};

MTS_IMPLEMENT_CLASS_VARIANT(SimpleTabulatedPhaseFunction, PhaseFunction)
MTS_EXPORT_PLUGIN(SimpleTabulatedPhaseFunction, "Tabulated phase function");
NAMESPACE_END(mitsuba)
