// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vmain.h for the primary calling header

#include "Vmain__pch.h"
#include "Vmain___024root.h"

VL_ATTR_COLD void Vmain___024root___eval_static__TOP(Vmain___024root* vlSelf);

VL_ATTR_COLD void Vmain___024root___eval_static(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_static\n"); );
    // Body
    Vmain___024root___eval_static__TOP(vlSelf);
}

VL_ATTR_COLD void Vmain___024root___eval_static__TOP(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_static__TOP\n"); );
    // Init
    IData/*31:0*/ main__DOT__l;
    main__DOT__l = 0;
    // Body
    vlSelf->main__DOT__last_time = 0.0;
    vlSelf->main__DOT__mesured_value = 0.0;
    vlSelf->main__DOT__last_error = 0.0;
    main__DOT__l = 0U;
    vlSelf->main__DOT__tmp_delta_time = 0.0;
    vlSelf->main__DOT__tmp_delta_error = 0.0;
}

VL_ATTR_COLD void Vmain___024root___eval_initial__TOP(Vmain___024root* vlSelf);

VL_ATTR_COLD void Vmain___024root___eval_initial(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_initial\n"); );
    // Body
    Vmain___024root___eval_initial__TOP(vlSelf);
}

VL_ATTR_COLD void Vmain___024root___eval_initial__TOP(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_initial__TOP\n"); );
    // Init
    IData/*31:0*/ main__DOT__l;
    main__DOT__l = 0;
    // Body
    main__DOT__l = 0U;
    while (VL_GTS_III(32, 0x64U, main__DOT__l)) {
        VL_WRITEF_NX("i: %11d\n",0,32,main__DOT__l);
        vlSelf->main__DOT__tmp_delta_time = ((1.00000000000000006e-01 
                                              * VL_ISTOR_D_I(32, main__DOT__l)) 
                                             - vlSelf->main__DOT__last_time);
        if (VL_UNLIKELY((vlSelf->main__DOT__tmp_delta_time 
                         > 0.0))) {
            vlSelf->main__DOT__tmp_delta_error = ((100.0 
                                                   - vlSelf->main__DOT__mesured_value) 
                                                  - vlSelf->main__DOT__last_error);
            vlSelf->main__DOT__last_time = (1.00000000000000006e-01 
                                            * VL_ISTOR_D_I(32, main__DOT__l));
            if ((0.0 == vlSelf->main__DOT__last_error)) {
                vlSelf->main__DOT__tmp_delta_error = 0.0;
            }
            vlSelf->main__DOT__last_error = (100.0 
                                             - vlSelf->main__DOT__mesured_value);
            vlSelf->main__DOT__mesured_value = (vlSelf->main__DOT__mesured_value 
                                                + (
                                                   ((5.99999999999999978e-01 
                                                     * 
                                                     (100.0 
                                                      - vlSelf->main__DOT__mesured_value)) 
                                                    + 
                                                    (5.0 
                                                     * 
                                                     ((100.0 
                                                       - vlSelf->main__DOT__mesured_value) 
                                                      * vlSelf->main__DOT__tmp_delta_time))) 
                                                   + 
                                                   (1.00000000000000005e-04 
                                                    * 
                                                    (vlSelf->main__DOT__tmp_delta_error 
                                                     / vlSelf->main__DOT__tmp_delta_time))));
            VL_WRITEF_NX("mesured_value: %f\n",0,64,
                         vlSelf->main__DOT__mesured_value);
        }
        main__DOT__l = ((IData)(1U) + main__DOT__l);
    }
}

VL_ATTR_COLD void Vmain___024root___eval_final(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vmain___024root___eval_settle(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_settle\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmain___024root___dump_triggers__act(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmain___024root___dump_triggers__nba(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vmain___024root___ctor_var_reset(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->main__DOT__last_time = 0;
    vlSelf->main__DOT__mesured_value = 0;
    vlSelf->main__DOT__last_error = 0;
    vlSelf->main__DOT__tmp_delta_time = 0;
    vlSelf->main__DOT__tmp_delta_error = 0;
}
