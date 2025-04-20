#include <mruby.h>

#define MAGNI_VERSION_STR(x) #x
#define MAGNI_VERSION_XSTR(x) MAGNI_VERSION_STR(x)

void mrb_magni_gem_init(mrb_state *mrb)
{
    mrb_define_global_const(mrb, "MAGNI_VERSION", mrb_str_new_cstr(mrb, MAGNI_VERSION_XSTR(MRBGEM_MAGNI_VERSION)));
}

void mrb_magni_gem_final(mrb_state *mrb)
{
}
