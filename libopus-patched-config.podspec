Pod::Spec.new do |s|
  s.name         = "libopus-patched-config"
  s.version      = "1.1"
  s.summary      = "Opus is a totally open, royalty-free, highly versatile audio codec. Patched to use local config.h file."

  s.description  = <<-DESC
                   Opus is a totally open, royalty-free, highly versatile audio codec. 
                   Opus is unmatched for interactive speech and music transmission over 
                   the Internet, but is also intended for storage and streaming 
                   applications. It is standardized by the Internet Engineering Task 
                   Force (IETF) as [RFC 6716][1] which incorporated technology from 
                   Skype's SILK codec and Xiph.Org's CELT codec.
                   
                    [1]: http://tools.ietf.org/html/rfc6716
                   DESC

  s.homepage     = "http://www.opus-codec.org/"

  s.license      = { :type => 'BSD', :file => 'COPYING' }

  s.author       = 'Xiph.Org', 'Skype Limited', 'Octasic',
                   'Jean-Marc Valin', 'Timothy B. Terriberry',
                   'CSIRO', 'Gregory Maxwell', 'Mark Borgerding',
                   'Erik de Castro Lopo'

  s.source       = { :http => "http://downloads.xiph.org/releases/opus/opus-#{s.version}.tar.gz" }
  s.requires_arc = false

  base_source_files = [
    'src/config.h', 'include/*.h', 
    'silk/*.{c,h}', 'celt/*.{c,h}'
  ]
  # Files from opus_sources.mk / opus_headers.mk
  base_source_files += [
    # OPUS_SOURCES
    "src/opus.c", "src/opus_decoder.c", "src/opus_encoder.c",
    "src/opus_multistream.c", "src/opus_multistream_encoder.c", "src/opus_multistream_decoder.c",
    "src/repacketizer.c",
    # OPUS_SOURCES_FLOAT
    "src/analysis.c", "src/mlp.c", "src/mlp_data.c",
    # OPUS_HEAD
    "include/opus.h", "include/opus_multistream.h", "src/opus_private.h", 
    "src/analysis.h", "src/mlp.h", "src/tansig_table.h"
  ]
  base_public_header_files = ['include/*.h']

  base_compiler_flags = ['-w', '-Xanalyzer', '-analyzer-disable-checker', '-DHAVE_CONFIG_H=1', '-O3']

  s.default_subspec = 'float'

  s.subspec 'fixed' do |fs|
    fs.source_files = base_source_files + ['silk/fixed']
    fs.public_header_files = base_public_header_files
    fs.exclude_files = "celt/opus_custom_demo.c"

    fs.compiler_flags = base_compiler_flags + ['-DFIXED_POINT']
  end
  s.subspec 'float' do |fs|
    fs.source_files = base_source_files + ['silk/float', 'celt/x86']
    fs.public_header_files = base_public_header_files
    fs.exclude_files = "celt/opus_custom_demo.c"

    fs.compiler_flags = base_compiler_flags + ['-DFLOATING_POINT']
  end

  s.xcconfig = {
    'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/libopus-patched-config/silk"'
  }

  s.prepare_command = <<-CMD
cat >src/config.h <<CONFIG_H
#define HAVE_DLFCN_H 1
#define HAVE_INTTYPES_H 1
#define HAVE_LRINT 1
#define HAVE_LRINTF 1
#define HAVE_MEMORY_H 1
#define HAVE_STDINT_H 1
#define HAVE_STDLIB_H 1
#define HAVE_STRINGS_H 1
#define HAVE_STRING_H 1
#define HAVE_SYS_STAT_H 1
#define HAVE_SYS_TYPES_H 1
#define HAVE_UNISTD_H 1

#define OPUS_BUILD /**/

#define STDC_HEADERS 1
#define VAR_ARRAYS 1

CONFIG_H

cat >config-include.patch <<CONFIG_INCLUDE
diff --git a/celt/arm/arm_celt_map.c b/celt/arm/arm_celt_map.c
index 547a84d..b510b4c 100644
--- a/celt/arm/arm_celt_map.c
+++ b/celt/arm/arm_celt_map.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "pitch.h"
diff --git a/celt/arm/armcpu.c b/celt/arm/armcpu.c
index 1768525..b9ee591 100644
--- a/celt/arm/armcpu.c
+++ b/celt/arm/armcpu.c
@@ -28,7 +28,7 @@
 /* Original code from libtheora modified to suit to Opus */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #ifdef OPUS_HAVE_RTCD
diff --git a/celt/bands.c b/celt/bands.c
index cce56e2..5ef1680 100644
--- a/celt/bands.c
+++ b/celt/bands.c
@@ -28,7 +28,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include <math.h>
diff --git a/celt/celt.c b/celt/celt.c
index 3e0ce6e..1a3990b 100644
--- a/celt/celt.c
+++ b/celt/celt.c
@@ -28,7 +28,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #define CELT_C
diff --git a/celt/celt_decoder.c b/celt/celt_decoder.c
index 830398e..f545aac 100644
--- a/celt/celt_decoder.c
+++ b/celt/celt_decoder.c
@@ -28,7 +28,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #define CELT_DECODER_C
diff --git a/celt/celt_encoder.c b/celt/celt_encoder.c
index ffff077..aeea47a 100644
--- a/celt/celt_encoder.c
+++ b/celt/celt_encoder.c
@@ -28,7 +28,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #define CELT_ENCODER_C
diff --git a/celt/celt_lpc.c b/celt/celt_lpc.c
index fa29d62..9c46df5 100644
--- a/celt/celt_lpc.c
+++ b/celt/celt_lpc.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "celt_lpc.h"
diff --git a/celt/cwrs.c b/celt/cwrs.c
index ad980cc..ded2425 100644
--- a/celt/cwrs.c
+++ b/celt/cwrs.c
@@ -28,7 +28,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "os_support.h"
diff --git a/celt/entcode.c b/celt/entcode.c
index fa5d7c7..121ac30 100644
--- a/celt/entcode.c
+++ b/celt/entcode.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "entcode.h"
diff --git a/celt/entdec.c b/celt/entdec.c
index 3c26468..90f41d1 100644
--- a/celt/entdec.c
+++ b/celt/entdec.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include <stddef.h>
diff --git a/celt/entenc.c b/celt/entenc.c
index a7e34ec..47cd264 100644
--- a/celt/entenc.c
+++ b/celt/entenc.c
@@ -26,7 +26,7 @@
 */
 
 #if defined(HAVE_CONFIG_H)
-# include "config.h"
+# include "./config.h"
 #endif
 #include "os_support.h"
 #include "arch.h"
diff --git a/celt/kiss_fft.c b/celt/kiss_fft.c
index ad706c7..c38a05f 100644
--- a/celt/kiss_fft.c
+++ b/celt/kiss_fft.c
@@ -31,7 +31,7 @@
 
 #ifndef SKIP_CONFIG_H
 #  ifdef HAVE_CONFIG_H
-#    include "config.h"
+#    include "./config.h"
 #  endif
 #endif
 
diff --git a/celt/laplace.c b/celt/laplace.c
index a7bca87..78fd289 100644
--- a/celt/laplace.c
+++ b/celt/laplace.c
@@ -27,7 +27,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "laplace.h"
diff --git a/celt/mathops.c b/celt/mathops.c
index 3f8c5dc..9988deb 100644
--- a/celt/mathops.c
+++ b/celt/mathops.c
@@ -32,7 +32,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "mathops.h"
diff --git a/celt/mdct.c b/celt/mdct.c
index 90a214a..bf99d89 100644
--- a/celt/mdct.c
+++ b/celt/mdct.c
@@ -41,7 +41,7 @@
 
 #ifndef SKIP_CONFIG_H
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 #endif
 
diff --git a/celt/modes.c b/celt/modes.c
index 42e68e1..acae833 100644
--- a/celt/modes.c
+++ b/celt/modes.c
@@ -28,7 +28,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "celt.h"
diff --git a/celt/opus_custom_demo.c b/celt/opus_custom_demo.c
index ae41c0d..011eeed 100644
--- a/celt/opus_custom_demo.c
+++ b/celt/opus_custom_demo.c
@@ -27,7 +27,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "opus_custom.h"
diff --git a/celt/pitch.c b/celt/pitch.c
index d2b3054..69bb2a1 100644
--- a/celt/pitch.c
+++ b/celt/pitch.c
@@ -32,7 +32,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "pitch.h"
diff --git a/celt/quant_bands.c b/celt/quant_bands.c
index ac6952c..9589d9e 100644
--- a/celt/quant_bands.c
+++ b/celt/quant_bands.c
@@ -27,7 +27,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "quant_bands.h"
diff --git a/celt/rate.c b/celt/rate.c
index e13d839..2df268d 100644
--- a/celt/rate.c
+++ b/celt/rate.c
@@ -27,7 +27,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include <math.h>
diff --git a/celt/tests/test_unit_cwrs32.c b/celt/tests/test_unit_cwrs32.c
index ac2a8d1..a15f57a 100644
--- a/celt/tests/test_unit_cwrs32.c
+++ b/celt/tests/test_unit_cwrs32.c
@@ -27,7 +27,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include <stdio.h>
diff --git a/celt/tests/test_unit_dft.c b/celt/tests/test_unit_dft.c
index 7ff0be0..efda007 100644
--- a/celt/tests/test_unit_dft.c
+++ b/celt/tests/test_unit_dft.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #define SKIP_CONFIG_H
diff --git a/celt/tests/test_unit_entropy.c b/celt/tests/test_unit_entropy.c
index bd83986..2289dae 100644
--- a/celt/tests/test_unit_entropy.c
+++ b/celt/tests/test_unit_entropy.c
@@ -27,7 +27,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include <stdlib.h>
diff --git a/celt/tests/test_unit_laplace.c b/celt/tests/test_unit_laplace.c
index b0f5935..8e5a4d9 100644
--- a/celt/tests/test_unit_laplace.c
+++ b/celt/tests/test_unit_laplace.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include <stdio.h>
diff --git a/celt/tests/test_unit_mathops.c b/celt/tests/test_unit_mathops.c
index 4bb780e..f9bb283 100644
--- a/celt/tests/test_unit_mathops.c
+++ b/celt/tests/test_unit_mathops.c
@@ -27,7 +27,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #ifndef CUSTOM_MODES
diff --git a/celt/tests/test_unit_mdct.c b/celt/tests/test_unit_mdct.c
index ac8957f..302d20d 100644
--- a/celt/tests/test_unit_mdct.c
+++ b/celt/tests/test_unit_mdct.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #define SKIP_CONFIG_H
diff --git a/celt/tests/test_unit_rotation.c b/celt/tests/test_unit_rotation.c
index ce5f096..2acf542 100644
--- a/celt/tests/test_unit_rotation.c
+++ b/celt/tests/test_unit_rotation.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #ifndef CUSTOM_MODES
diff --git a/celt/tests/test_unit_types.c b/celt/tests/test_unit_types.c
index 67a0fb8..e523e7f 100644
--- a/celt/tests/test_unit_types.c
+++ b/celt/tests/test_unit_types.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "opus_types.h"
diff --git a/celt/vq.c b/celt/vq.c
index 98a0f36..bb39fcd 100644
--- a/celt/vq.c
+++ b/celt/vq.c
@@ -27,7 +27,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "mathops.h"
diff --git a/silk/A2NLSF.c b/silk/A2NLSF.c
index 74b1b95..55a10aa 100644
--- a/silk/A2NLSF.c
+++ b/silk/A2NLSF.c
@@ -32,7 +32,7 @@ POSSIBILITY OF SUCH DAMAGE.
 /* functions are accurate inverses of each other                */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/CNG.c b/silk/CNG.c
index 8481d95..c16b527 100644
--- a/silk/CNG.c
+++ b/silk/CNG.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/HP_variable_cutoff.c b/silk/HP_variable_cutoff.c
index bbe10f0..73beba4 100644
--- a/silk/HP_variable_cutoff.c
+++ b/silk/HP_variable_cutoff.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 #ifdef FIXED_POINT
 #include "main_FIX.h"
diff --git a/silk/LPC_analysis_filter.c b/silk/LPC_analysis_filter.c
index 9d1f16c..2c60d34 100644
--- a/silk/LPC_analysis_filter.c
+++ b/silk/LPC_analysis_filter.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/LPC_inv_pred_gain.c b/silk/LPC_inv_pred_gain.c
index 4af89aa..67b273d 100644
--- a/silk/LPC_inv_pred_gain.c
+++ b/silk/LPC_inv_pred_gain.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/LP_variable_cutoff.c b/silk/LP_variable_cutoff.c
index f639e1f..02d505e 100644
--- a/silk/LP_variable_cutoff.c
+++ b/silk/LP_variable_cutoff.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 /*
diff --git a/silk/NLSF2A.c b/silk/NLSF2A.c
index b1c559e..97c0d36 100644
--- a/silk/NLSF2A.c
+++ b/silk/NLSF2A.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 /* conversion between prediction filter coefficients and LSFs   */
diff --git a/silk/NLSF_VQ.c b/silk/NLSF_VQ.c
index 69b6e22..678052c 100644
--- a/silk/NLSF_VQ.c
+++ b/silk/NLSF_VQ.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/NLSF_VQ_weights_laroia.c b/silk/NLSF_VQ_weights_laroia.c
index 04894c5..f848078 100644
--- a/silk/NLSF_VQ_weights_laroia.c
+++ b/silk/NLSF_VQ_weights_laroia.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "define.h"
diff --git a/silk/NLSF_decode.c b/silk/NLSF_decode.c
index 9f71506..79de124 100644
--- a/silk/NLSF_decode.c
+++ b/silk/NLSF_decode.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/NLSF_del_dec_quant.c b/silk/NLSF_del_dec_quant.c
index 504dbbd..438e0e6 100644
--- a/silk/NLSF_del_dec_quant.c
+++ b/silk/NLSF_del_dec_quant.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/NLSF_encode.c b/silk/NLSF_encode.c
index 03a036f..fc1949e 100644
--- a/silk/NLSF_encode.c
+++ b/silk/NLSF_encode.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/NLSF_stabilize.c b/silk/NLSF_stabilize.c
index 1fa1ea3..ab7f0cd 100644
--- a/silk/NLSF_stabilize.c
+++ b/silk/NLSF_stabilize.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 /* NLSF stabilizer:                                         */
diff --git a/silk/NLSF_unpack.c b/silk/NLSF_unpack.c
index 17bd23f..03bd78c 100644
--- a/silk/NLSF_unpack.c
+++ b/silk/NLSF_unpack.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/NSQ.c b/silk/NSQ.c
index cf5b3fd..32c47a8 100644
--- a/silk/NSQ.c
+++ b/silk/NSQ.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/NSQ_del_dec.c b/silk/NSQ_del_dec.c
index 522be40..d4ec6c6 100644
--- a/silk/NSQ_del_dec.c
+++ b/silk/NSQ_del_dec.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/PLC.c b/silk/PLC.c
index 01f4001..f438ee7 100644
--- a/silk/PLC.c
+++ b/silk/PLC.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/VAD.c b/silk/VAD.c
index a809098..8df2962 100644
--- a/silk/VAD.c
+++ b/silk/VAD.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/VQ_WMat_EC.c b/silk/VQ_WMat_EC.c
index 13d5d34..6851b9e 100644
--- a/silk/VQ_WMat_EC.c
+++ b/silk/VQ_WMat_EC.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/ana_filt_bank_1.c b/silk/ana_filt_bank_1.c
index 24cfb03..e768a4e 100644
--- a/silk/ana_filt_bank_1.c
+++ b/silk/ana_filt_bank_1.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/biquad_alt.c b/silk/biquad_alt.c
index d55f5ee..2b79ccd 100644
--- a/silk/biquad_alt.c
+++ b/silk/biquad_alt.c
@@ -33,7 +33,7 @@ POSSIBILITY OF SUCH DAMAGE.
  *                                                                      */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/bwexpander.c b/silk/bwexpander.c
index 2eb4456..af4c0f0 100644
--- a/silk/bwexpander.c
+++ b/silk/bwexpander.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/bwexpander_32.c b/silk/bwexpander_32.c
index d0010f7..d627d8f 100644
--- a/silk/bwexpander_32.c
+++ b/silk/bwexpander_32.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/check_control_input.c b/silk/check_control_input.c
index b5de9ce..c07b8f7 100644
--- a/silk/check_control_input.c
+++ b/silk/check_control_input.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/code_signs.c b/silk/code_signs.c
index 0419ea2..48790df 100644
--- a/silk/code_signs.c
+++ b/silk/code_signs.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/control_SNR.c b/silk/control_SNR.c
index f04e69f..b16ab34 100644
--- a/silk/control_SNR.c
+++ b/silk/control_SNR.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/control_audio_bandwidth.c b/silk/control_audio_bandwidth.c
index 4f9bc5c..4c8c4a4 100644
--- a/silk/control_audio_bandwidth.c
+++ b/silk/control_audio_bandwidth.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/control_codec.c b/silk/control_codec.c
index 1f674bd..7da686d 100644
--- a/silk/control_codec.c
+++ b/silk/control_codec.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 #ifdef FIXED_POINT
 #include "main_FIX.h"
diff --git a/silk/debug.c b/silk/debug.c
index 9253faf..51e5c82 100644
--- a/silk/debug.c
+++ b/silk/debug.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "debug.h"
diff --git a/silk/dec_API.c b/silk/dec_API.c
index 4cbcf71..eab7032 100644
--- a/silk/dec_API.c
+++ b/silk/dec_API.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 #include "API.h"
 #include "main.h"
diff --git a/silk/decode_core.c b/silk/decode_core.c
index a820bf1..544f868 100644
--- a/silk/decode_core.c
+++ b/silk/decode_core.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/decode_frame.c b/silk/decode_frame.c
index abc00a3..8eed659 100644
--- a/silk/decode_frame.c
+++ b/silk/decode_frame.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/decode_indices.c b/silk/decode_indices.c
index 7afe5c2..541313c 100644
--- a/silk/decode_indices.c
+++ b/silk/decode_indices.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/decode_parameters.c b/silk/decode_parameters.c
index e345b1d..52d2a90 100644
--- a/silk/decode_parameters.c
+++ b/silk/decode_parameters.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/decode_pitch.c b/silk/decode_pitch.c
index fedbc6a..e2cc57e 100644
--- a/silk/decode_pitch.c
+++ b/silk/decode_pitch.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 /***********************************************************
diff --git a/silk/decode_pulses.c b/silk/decode_pulses.c
index e8a87c2..15dc675 100644
--- a/silk/decode_pulses.c
+++ b/silk/decode_pulses.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/decoder_set_fs.c b/silk/decoder_set_fs.c
index eef0fd2..e3d5ab4 100644
--- a/silk/decoder_set_fs.c
+++ b/silk/decoder_set_fs.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/enc_API.c b/silk/enc_API.c
index 43739ef..80a74fd 100644
--- a/silk/enc_API.c
+++ b/silk/enc_API.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 #include "define.h"
 #include "API.h"
diff --git a/silk/encode_indices.c b/silk/encode_indices.c
index 666c8c0..109d505 100644
--- a/silk/encode_indices.c
+++ b/silk/encode_indices.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/encode_pulses.c b/silk/encode_pulses.c
index a450143..bfee19e 100644
--- a/silk/encode_pulses.c
+++ b/silk/encode_pulses.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/fixed/LTP_analysis_filter_FIX.c b/silk/fixed/LTP_analysis_filter_FIX.c
index a941908..7795473 100644
--- a/silk/fixed/LTP_analysis_filter_FIX.c
+++ b/silk/fixed/LTP_analysis_filter_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/fixed/LTP_scale_ctrl_FIX.c b/silk/fixed/LTP_scale_ctrl_FIX.c
index 3dcedef..d4f17c7 100644
--- a/silk/fixed/LTP_scale_ctrl_FIX.c
+++ b/silk/fixed/LTP_scale_ctrl_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/fixed/apply_sine_window_FIX.c b/silk/fixed/apply_sine_window_FIX.c
index 4502b71..84d2f85 100644
--- a/silk/fixed/apply_sine_window_FIX.c
+++ b/silk/fixed/apply_sine_window_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/fixed/autocorr_FIX.c b/silk/fixed/autocorr_FIX.c
index de95c98..7564a11 100644
--- a/silk/fixed/autocorr_FIX.c
+++ b/silk/fixed/autocorr_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/fixed/burg_modified_FIX.c b/silk/fixed/burg_modified_FIX.c
index db34829..ff9c166 100644
--- a/silk/fixed/burg_modified_FIX.c
+++ b/silk/fixed/burg_modified_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/fixed/corrMatrix_FIX.c b/silk/fixed/corrMatrix_FIX.c
index c617270..3b1caf6 100644
--- a/silk/fixed/corrMatrix_FIX.c
+++ b/silk/fixed/corrMatrix_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 /**********************************************************************
diff --git a/silk/fixed/encode_frame_FIX.c b/silk/fixed/encode_frame_FIX.c
index b490986..822edd6 100644
--- a/silk/fixed/encode_frame_FIX.c
+++ b/silk/fixed/encode_frame_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/fixed/find_LPC_FIX.c b/silk/fixed/find_LPC_FIX.c
index 783d32e..1f72b21 100644
--- a/silk/fixed/find_LPC_FIX.c
+++ b/silk/fixed/find_LPC_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/fixed/find_LTP_FIX.c b/silk/fixed/find_LTP_FIX.c
index 8c4d703..89add59 100644
--- a/silk/fixed/find_LTP_FIX.c
+++ b/silk/fixed/find_LTP_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/fixed/find_pitch_lags_FIX.c b/silk/fixed/find_pitch_lags_FIX.c
index 620f8dc..ca52789 100644
--- a/silk/fixed/find_pitch_lags_FIX.c
+++ b/silk/fixed/find_pitch_lags_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/fixed/find_pred_coefs_FIX.c b/silk/fixed/find_pred_coefs_FIX.c
index 5c22f82..1c11fc8 100644
--- a/silk/fixed/find_pred_coefs_FIX.c
+++ b/silk/fixed/find_pred_coefs_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/fixed/k2a_FIX.c b/silk/fixed/k2a_FIX.c
index 5fee599..2cb278b 100644
--- a/silk/fixed/k2a_FIX.c
+++ b/silk/fixed/k2a_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/fixed/k2a_Q16_FIX.c b/silk/fixed/k2a_Q16_FIX.c
index 3b03987..4e6020d 100644
--- a/silk/fixed/k2a_Q16_FIX.c
+++ b/silk/fixed/k2a_Q16_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/fixed/noise_shape_analysis_FIX.c b/silk/fixed/noise_shape_analysis_FIX.c
index e24d2e9..aa70b46 100644
--- a/silk/fixed/noise_shape_analysis_FIX.c
+++ b/silk/fixed/noise_shape_analysis_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/fixed/pitch_analysis_core_FIX.c b/silk/fixed/pitch_analysis_core_FIX.c
index 1641a0f..3a55ac1 100644
--- a/silk/fixed/pitch_analysis_core_FIX.c
+++ b/silk/fixed/pitch_analysis_core_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 /***********************************************************
diff --git a/silk/fixed/prefilter_FIX.c b/silk/fixed/prefilter_FIX.c
index d381730..d5f9bb1 100644
--- a/silk/fixed/prefilter_FIX.c
+++ b/silk/fixed/prefilter_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/fixed/process_gains_FIX.c b/silk/fixed/process_gains_FIX.c
index 05aba31..562f30f 100644
--- a/silk/fixed/process_gains_FIX.c
+++ b/silk/fixed/process_gains_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/fixed/regularize_correlations_FIX.c b/silk/fixed/regularize_correlations_FIX.c
index a2836b0..509630d 100644
--- a/silk/fixed/regularize_correlations_FIX.c
+++ b/silk/fixed/regularize_correlations_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/fixed/residual_energy16_FIX.c b/silk/fixed/residual_energy16_FIX.c
index ebffb2a..a4587f5 100644
--- a/silk/fixed/residual_energy16_FIX.c
+++ b/silk/fixed/residual_energy16_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/fixed/residual_energy_FIX.c b/silk/fixed/residual_energy_FIX.c
index 105ae31..26f17d3 100644
--- a/silk/fixed/residual_energy_FIX.c
+++ b/silk/fixed/residual_energy_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/fixed/schur64_FIX.c b/silk/fixed/schur64_FIX.c
index 764a10e..8abb09f 100644
--- a/silk/fixed/schur64_FIX.c
+++ b/silk/fixed/schur64_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/fixed/schur_FIX.c b/silk/fixed/schur_FIX.c
index c4c0ef2..109bb6c 100644
--- a/silk/fixed/schur_FIX.c
+++ b/silk/fixed/schur_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/fixed/solve_LS_FIX.c b/silk/fixed/solve_LS_FIX.c
index 51d7d49..8e70055 100644
--- a/silk/fixed/solve_LS_FIX.c
+++ b/silk/fixed/solve_LS_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/fixed/vector_ops_FIX.c b/silk/fixed/vector_ops_FIX.c
index 509c8b3..6268b0f 100644
--- a/silk/fixed/vector_ops_FIX.c
+++ b/silk/fixed/vector_ops_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/fixed/warped_autocorrelation_FIX.c b/silk/fixed/warped_autocorrelation_FIX.c
index a4a579b..21dece6 100644
--- a/silk/fixed/warped_autocorrelation_FIX.c
+++ b/silk/fixed/warped_autocorrelation_FIX.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FIX.h"
diff --git a/silk/float/LPC_analysis_filter_FLP.c b/silk/float/LPC_analysis_filter_FLP.c
index cae89a0..d19229d 100644
--- a/silk/float/LPC_analysis_filter_FLP.c
+++ b/silk/float/LPC_analysis_filter_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include <stdlib.h>
diff --git a/silk/float/LPC_inv_pred_gain_FLP.c b/silk/float/LPC_inv_pred_gain_FLP.c
index 25178ba..9aa07fa 100644
--- a/silk/float/LPC_inv_pred_gain_FLP.c
+++ b/silk/float/LPC_inv_pred_gain_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/float/LTP_analysis_filter_FLP.c b/silk/float/LTP_analysis_filter_FLP.c
index 849b7c1..3c529a5 100644
--- a/silk/float/LTP_analysis_filter_FLP.c
+++ b/silk/float/LTP_analysis_filter_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FLP.h"
diff --git a/silk/float/LTP_scale_ctrl_FLP.c b/silk/float/LTP_scale_ctrl_FLP.c
index 8dbe29d..d7b44e4 100644
--- a/silk/float/LTP_scale_ctrl_FLP.c
+++ b/silk/float/LTP_scale_ctrl_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FLP.h"
diff --git a/silk/float/apply_sine_window_FLP.c b/silk/float/apply_sine_window_FLP.c
index 6aae57c..006ba70 100644
--- a/silk/float/apply_sine_window_FLP.c
+++ b/silk/float/apply_sine_window_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FLP.h"
diff --git a/silk/float/autocorrelation_FLP.c b/silk/float/autocorrelation_FLP.c
index 8b8a9e6..d100279 100644
--- a/silk/float/autocorrelation_FLP.c
+++ b/silk/float/autocorrelation_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "typedef.h"
diff --git a/silk/float/burg_modified_FLP.c b/silk/float/burg_modified_FLP.c
index ea5dc25..d6e3f37 100644
--- a/silk/float/burg_modified_FLP.c
+++ b/silk/float/burg_modified_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FLP.h"
diff --git a/silk/float/bwexpander_FLP.c b/silk/float/bwexpander_FLP.c
index d55a4d7..8032594 100644
--- a/silk/float/bwexpander_FLP.c
+++ b/silk/float/bwexpander_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FLP.h"
diff --git a/silk/float/corrMatrix_FLP.c b/silk/float/corrMatrix_FLP.c
index eae6a1c..a46d732 100644
--- a/silk/float/corrMatrix_FLP.c
+++ b/silk/float/corrMatrix_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 /**********************************************************************
diff --git a/silk/float/encode_frame_FLP.c b/silk/float/encode_frame_FLP.c
index d54e268..b8ff8cd 100644
--- a/silk/float/encode_frame_FLP.c
+++ b/silk/float/encode_frame_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FLP.h"
diff --git a/silk/float/energy_FLP.c b/silk/float/energy_FLP.c
index 24b8179..cabbae1 100644
--- a/silk/float/energy_FLP.c
+++ b/silk/float/energy_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FLP.h"
diff --git a/silk/float/find_LPC_FLP.c b/silk/float/find_LPC_FLP.c
index 61c1ad9..7539ee5 100644
--- a/silk/float/find_LPC_FLP.c
+++ b/silk/float/find_LPC_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "define.h"
diff --git a/silk/float/find_LTP_FLP.c b/silk/float/find_LTP_FLP.c
index 7229996..486f051 100644
--- a/silk/float/find_LTP_FLP.c
+++ b/silk/float/find_LTP_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FLP.h"
diff --git a/silk/float/find_pitch_lags_FLP.c b/silk/float/find_pitch_lags_FLP.c
index f3b22d2..8611747 100644
--- a/silk/float/find_pitch_lags_FLP.c
+++ b/silk/float/find_pitch_lags_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include <stdlib.h>
diff --git a/silk/float/find_pred_coefs_FLP.c b/silk/float/find_pred_coefs_FLP.c
index ea2c6c4..faa7b91 100644
--- a/silk/float/find_pred_coefs_FLP.c
+++ b/silk/float/find_pred_coefs_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FLP.h"
diff --git a/silk/float/inner_product_FLP.c b/silk/float/inner_product_FLP.c
index 029c012..a95e57e 100644
--- a/silk/float/inner_product_FLP.c
+++ b/silk/float/inner_product_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FLP.h"
diff --git a/silk/float/k2a_FLP.c b/silk/float/k2a_FLP.c
index 12af4e7..4da7037 100644
--- a/silk/float/k2a_FLP.c
+++ b/silk/float/k2a_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FLP.h"
diff --git a/silk/float/levinsondurbin_FLP.c b/silk/float/levinsondurbin_FLP.c
index f0ba606..c1532f1 100644
--- a/silk/float/levinsondurbin_FLP.c
+++ b/silk/float/levinsondurbin_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FLP.h"
diff --git a/silk/float/noise_shape_analysis_FLP.c b/silk/float/noise_shape_analysis_FLP.c
index 65f6ea5..fc61076 100644
--- a/silk/float/noise_shape_analysis_FLP.c
+++ b/silk/float/noise_shape_analysis_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FLP.h"
diff --git a/silk/float/pitch_analysis_core_FLP.c b/silk/float/pitch_analysis_core_FLP.c
index e58f041..e7dd5d4 100644
--- a/silk/float/pitch_analysis_core_FLP.c
+++ b/silk/float/pitch_analysis_core_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 /*****************************************************************************
diff --git a/silk/float/prefilter_FLP.c b/silk/float/prefilter_FLP.c
index 8bc32fb..427f86b 100644
--- a/silk/float/prefilter_FLP.c
+++ b/silk/float/prefilter_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FLP.h"
diff --git a/silk/float/process_gains_FLP.c b/silk/float/process_gains_FLP.c
index c0da0da..f13ba12 100644
--- a/silk/float/process_gains_FLP.c
+++ b/silk/float/process_gains_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FLP.h"
diff --git a/silk/float/regularize_correlations_FLP.c b/silk/float/regularize_correlations_FLP.c
index df46126..1623924 100644
--- a/silk/float/regularize_correlations_FLP.c
+++ b/silk/float/regularize_correlations_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FLP.h"
diff --git a/silk/float/residual_energy_FLP.c b/silk/float/residual_energy_FLP.c
index b2e03a8..16816f9 100644
--- a/silk/float/residual_energy_FLP.c
+++ b/silk/float/residual_energy_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FLP.h"
diff --git a/silk/float/scale_copy_vector_FLP.c b/silk/float/scale_copy_vector_FLP.c
index 20db32b..1b8ddbe 100644
--- a/silk/float/scale_copy_vector_FLP.c
+++ b/silk/float/scale_copy_vector_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FLP.h"
diff --git a/silk/float/scale_vector_FLP.c b/silk/float/scale_vector_FLP.c
index 108fdcb..852aba1 100644
--- a/silk/float/scale_vector_FLP.c
+++ b/silk/float/scale_vector_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FLP.h"
diff --git a/silk/float/schur_FLP.c b/silk/float/schur_FLP.c
index ee436f8..e358905 100644
--- a/silk/float/schur_FLP.c
+++ b/silk/float/schur_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FLP.h"
diff --git a/silk/float/solve_LS_FLP.c b/silk/float/solve_LS_FLP.c
index 7c90d66..94a6b7f 100644
--- a/silk/float/solve_LS_FLP.c
+++ b/silk/float/solve_LS_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FLP.h"
diff --git a/silk/float/sort_FLP.c b/silk/float/sort_FLP.c
index f08d759..2abc538 100644
--- a/silk/float/sort_FLP.c
+++ b/silk/float/sort_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 /* Insertion sort (fast for already almost sorted arrays):  */
diff --git a/silk/float/warped_autocorrelation_FLP.c b/silk/float/warped_autocorrelation_FLP.c
index 542414f..9bd80f8 100644
--- a/silk/float/warped_autocorrelation_FLP.c
+++ b/silk/float/warped_autocorrelation_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FLP.h"
diff --git a/silk/float/wrappers_FLP.c b/silk/float/wrappers_FLP.c
index 350599b..3ac360b 100644
--- a/silk/float/wrappers_FLP.c
+++ b/silk/float/wrappers_FLP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main_FLP.h"
diff --git a/silk/gain_quant.c b/silk/gain_quant.c
index 64ccd06..943362a 100644
--- a/silk/gain_quant.c
+++ b/silk/gain_quant.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/init_decoder.c b/silk/init_decoder.c
index f887c67..e38ac06 100644
--- a/silk/init_decoder.c
+++ b/silk/init_decoder.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/init_encoder.c b/silk/init_encoder.c
index 65995c3..c0e8c50 100644
--- a/silk/init_encoder.c
+++ b/silk/init_encoder.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 #ifdef FIXED_POINT
 #include "main_FIX.h"
diff --git a/silk/inner_prod_aligned.c b/silk/inner_prod_aligned.c
index 257ae9e..7476167 100644
--- a/silk/inner_prod_aligned.c
+++ b/silk/inner_prod_aligned.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/interpolate.c b/silk/interpolate.c
index 1bd8ca4..cc39de9 100644
--- a/silk/interpolate.c
+++ b/silk/interpolate.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/lin2log.c b/silk/lin2log.c
index d4fe515..06000f0 100644
--- a/silk/lin2log.c
+++ b/silk/lin2log.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/log2lin.c b/silk/log2lin.c
index a692e00..b14700f 100644
--- a/silk/log2lin.c
+++ b/silk/log2lin.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/macros.h b/silk/macros.h
index a84e5a5..0b7c4fb 100644
--- a/silk/macros.h
+++ b/silk/macros.h
@@ -29,7 +29,7 @@ POSSIBILITY OF SUCH DAMAGE.
 #define SILK_MACROS_H
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "opus_types.h"
diff --git a/silk/pitch_est_tables.c b/silk/pitch_est_tables.c
index 81a8bac..728dee6 100644
--- a/silk/pitch_est_tables.c
+++ b/silk/pitch_est_tables.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "typedef.h"
diff --git a/silk/process_NLSFs.c b/silk/process_NLSFs.c
index c27cf03..751040d 100644
--- a/silk/process_NLSFs.c
+++ b/silk/process_NLSFs.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/quant_LTP_gains.c b/silk/quant_LTP_gains.c
index fd0870d..122457b 100644
--- a/silk/quant_LTP_gains.c
+++ b/silk/quant_LTP_gains.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/resampler.c b/silk/resampler.c
index 374fbb3..3494f71 100644
--- a/silk/resampler.c
+++ b/silk/resampler.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 /*
diff --git a/silk/resampler_down2.c b/silk/resampler_down2.c
index cec3634..8ee0aab 100644
--- a/silk/resampler_down2.c
+++ b/silk/resampler_down2.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/resampler_down2_3.c b/silk/resampler_down2_3.c
index 4342614..983595c 100644
--- a/silk/resampler_down2_3.c
+++ b/silk/resampler_down2_3.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/resampler_private_AR2.c b/silk/resampler_private_AR2.c
index 5fff237..74b60b9 100644
--- a/silk/resampler_private_AR2.c
+++ b/silk/resampler_private_AR2.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/resampler_private_IIR_FIR.c b/silk/resampler_private_IIR_FIR.c
index 6b2b3a2..acd6c6a 100644
--- a/silk/resampler_private_IIR_FIR.c
+++ b/silk/resampler_private_IIR_FIR.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/resampler_private_down_FIR.c b/silk/resampler_private_down_FIR.c
index 783e42b..b7c6c05 100644
--- a/silk/resampler_private_down_FIR.c
+++ b/silk/resampler_private_down_FIR.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/resampler_private_up2_HQ.c b/silk/resampler_private_up2_HQ.c
index c7ec8de..e201f2c 100644
--- a/silk/resampler_private_up2_HQ.c
+++ b/silk/resampler_private_up2_HQ.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/resampler_rom.c b/silk/resampler_rom.c
index 2d50270..d7462c8 100644
--- a/silk/resampler_rom.c
+++ b/silk/resampler_rom.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 /* Filter coefficients for IIR/FIR polyphase resampling     *
diff --git a/silk/shell_coder.c b/silk/shell_coder.c
index 796f57d..678b9f8 100644
--- a/silk/shell_coder.c
+++ b/silk/shell_coder.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/sigm_Q15.c b/silk/sigm_Q15.c
index 3c507d2..18df68a 100644
--- a/silk/sigm_Q15.c
+++ b/silk/sigm_Q15.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 /* Approximate sigmoid function */
diff --git a/silk/sort.c b/silk/sort.c
index 8670dbd..3649f08 100644
--- a/silk/sort.c
+++ b/silk/sort.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 /* Insertion sort (fast for already almost sorted arrays):   */
diff --git a/silk/stereo_LR_to_MS.c b/silk/stereo_LR_to_MS.c
index 42906e6..48cce53 100644
--- a/silk/stereo_LR_to_MS.c
+++ b/silk/stereo_LR_to_MS.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/stereo_MS_to_LR.c b/silk/stereo_MS_to_LR.c
index 62521a4..883dcf1 100644
--- a/silk/stereo_MS_to_LR.c
+++ b/silk/stereo_MS_to_LR.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/stereo_decode_pred.c b/silk/stereo_decode_pred.c
index 56ba392..8e6c8c4 100644
--- a/silk/stereo_decode_pred.c
+++ b/silk/stereo_decode_pred.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/stereo_encode_pred.c b/silk/stereo_encode_pred.c
index e6dd195..770978e 100644
--- a/silk/stereo_encode_pred.c
+++ b/silk/stereo_encode_pred.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/stereo_find_predictor.c b/silk/stereo_find_predictor.c
index e30e90b..39c9e33 100644
--- a/silk/stereo_find_predictor.c
+++ b/silk/stereo_find_predictor.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/stereo_quant_pred.c b/silk/stereo_quant_pred.c
index d4ced6c..2d474d6 100644
--- a/silk/stereo_quant_pred.c
+++ b/silk/stereo_quant_pred.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "main.h"
diff --git a/silk/sum_sqr_shift.c b/silk/sum_sqr_shift.c
index 12514c9..a2787ac 100644
--- a/silk/sum_sqr_shift.c
+++ b/silk/sum_sqr_shift.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "SigProc_FIX.h"
diff --git a/silk/table_LSF_cos.c b/silk/table_LSF_cos.c
index ec9dc63..ea3eec8 100644
--- a/silk/table_LSF_cos.c
+++ b/silk/table_LSF_cos.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "tables.h"
diff --git a/silk/tables_LTP.c b/silk/tables_LTP.c
index 0e6a025..1d9c283 100644
--- a/silk/tables_LTP.c
+++ b/silk/tables_LTP.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "tables.h"
diff --git a/silk/tables_NLSF_CB_NB_MB.c b/silk/tables_NLSF_CB_NB_MB.c
index 8c59d20..976de8d 100644
--- a/silk/tables_NLSF_CB_NB_MB.c
+++ b/silk/tables_NLSF_CB_NB_MB.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "tables.h"
diff --git a/silk/tables_NLSF_CB_WB.c b/silk/tables_NLSF_CB_WB.c
index 50af87e..cd33ba3 100644
--- a/silk/tables_NLSF_CB_WB.c
+++ b/silk/tables_NLSF_CB_WB.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "tables.h"
diff --git a/silk/tables_gain.c b/silk/tables_gain.c
index 37e41d8..ab3be84 100644
--- a/silk/tables_gain.c
+++ b/silk/tables_gain.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "tables.h"
diff --git a/silk/tables_other.c b/silk/tables_other.c
index 398686b..471c578 100644
--- a/silk/tables_other.c
+++ b/silk/tables_other.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "structs.h"
diff --git a/silk/tables_pitch_lag.c b/silk/tables_pitch_lag.c
index e80cc59..6364029 100644
--- a/silk/tables_pitch_lag.c
+++ b/silk/tables_pitch_lag.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "tables.h"
diff --git a/silk/tables_pulses_per_block.c b/silk/tables_pulses_per_block.c
index c7c01c8..c4d3e86 100644
--- a/silk/tables_pulses_per_block.c
+++ b/silk/tables_pulses_per_block.c
@@ -26,7 +26,7 @@ POSSIBILITY OF SUCH DAMAGE.
 ***********************************************************************/
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "tables.h"
diff --git a/src/analysis.c b/src/analysis.c
index 778a62a..8808be6 100644
--- a/src/analysis.c
+++ b/src/analysis.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "kiss_fft.h"
diff --git a/src/mlp.c b/src/mlp.c
index 4638602..5478f63 100644
--- a/src/mlp.c
+++ b/src/mlp.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "opus_types.h"
diff --git a/src/opus.c b/src/opus.c
index 30890b9..29d8904 100644
--- a/src/opus.c
+++ b/src/opus.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "opus.h"
diff --git a/src/opus_decoder.c b/src/opus_decoder.c
index 919ba52..ca9ec3c 100644
--- a/src/opus_decoder.c
+++ b/src/opus_decoder.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-# include "config.h"
+# include "./config.h"
 #endif
 
 #ifndef OPUS_BUILD
diff --git a/src/opus_demo.c b/src/opus_demo.c
index f8cdf03..40527a5 100644
--- a/src/opus_demo.c
+++ b/src/opus_demo.c
@@ -27,7 +27,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include <stdio.h>
diff --git a/src/opus_encoder.c b/src/opus_encoder.c
index fbd3de6..fa03234 100644
--- a/src/opus_encoder.c
+++ b/src/opus_encoder.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include <stdarg.h>
diff --git a/src/opus_multistream.c b/src/opus_multistream.c
index 09c3639..1d91820 100644
--- a/src/opus_multistream.c
+++ b/src/opus_multistream.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "opus_multistream.h"
diff --git a/src/opus_multistream_decoder.c b/src/opus_multistream_decoder.c
index a05fa1e..fdafdbb 100644
--- a/src/opus_multistream_decoder.c
+++ b/src/opus_multistream_decoder.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "opus_multistream.h"
diff --git a/src/opus_multistream_encoder.c b/src/opus_multistream_encoder.c
index 49e2791..eb7e632 100644
--- a/src/opus_multistream_encoder.c
+++ b/src/opus_multistream_encoder.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "opus_multistream.h"
diff --git a/src/repacketizer.c b/src/repacketizer.c
index a62675c..ec0cd28 100644
--- a/src/repacketizer.c
+++ b/src/repacketizer.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "opus.h"
diff --git a/src/repacketizer_demo.c b/src/repacketizer_demo.c
index dc05c1b..4881560 100644
--- a/src/repacketizer_demo.c
+++ b/src/repacketizer_demo.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include "opus.h"
diff --git a/tests/test_opus_api.c b/tests/test_opus_api.c
index bafe4e4..94f92a1 100644
--- a/tests/test_opus_api.c
+++ b/tests/test_opus_api.c
@@ -42,7 +42,7 @@
    run inside valgrind. Malloc failure testing requires glibc. */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include <stdio.h>
diff --git a/tests/test_opus_decode.c b/tests/test_opus_decode.c
index 9c0eb9c..72859cc 100644
--- a/tests/test_opus_decode.c
+++ b/tests/test_opus_decode.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include <stdio.h>
diff --git a/tests/test_opus_encode.c b/tests/test_opus_encode.c
index 132d074..327bd48 100644
--- a/tests/test_opus_encode.c
+++ b/tests/test_opus_encode.c
@@ -26,7 +26,7 @@
 */
 
 #ifdef HAVE_CONFIG_H
-#include "config.h"
+#include "./config.h"
 #endif
 
 #include <stdio.h>
-- 
2.4.2

CONFIG_INCLUDE

patch -p1 < config-include.patch
  CMD

end
