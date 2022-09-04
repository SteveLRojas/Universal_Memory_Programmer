/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/ise/VM_share/Nexys2_PMOD_Programmer/I2C_ri.v";
static unsigned int ng1[] = {0U, 0U};
static unsigned int ng2[] = {1U, 0U};



static void Cont_33_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;

LAB0:    t1 = (t0 + 5400U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(33, ng0);
    t2 = (t0 + 2808U);
    t3 = *((char **)t2);
    t2 = (t0 + 6064);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memset(t7, 0, 8);
    t8 = 1U;
    t9 = t8;
    t10 = (t3 + 4);
    t11 = *((unsigned int *)t3);
    t8 = (t8 & t11);
    t12 = *((unsigned int *)t10);
    t9 = (t9 & t12);
    t13 = (t7 + 4);
    t14 = *((unsigned int *)t7);
    *((unsigned int *)t7) = (t14 | t8);
    t15 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t15 | t9);
    xsi_driver_vfirst_trans(t2, 0, 0);
    t16 = (t0 + 5968);
    *((int *)t16) = 1;

LAB1:    return;
}

static void Always_35_1(char *t0)
{
    char t13[8];
    char t14[8];
    char t18[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    char *t30;
    char *t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    int t38;
    int t39;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    unsigned int t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    unsigned int t66;
    unsigned int t67;
    unsigned int t68;
    char *t69;
    char *t70;
    unsigned int t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    unsigned int t75;
    unsigned int t76;
    unsigned int t77;
    unsigned int t78;
    int t79;
    int t80;
    unsigned int t81;
    unsigned int t82;
    unsigned int t83;
    unsigned int t84;
    unsigned int t85;
    unsigned int t86;
    char *t87;
    unsigned int t88;
    unsigned int t89;
    unsigned int t90;
    unsigned int t91;
    unsigned int t92;
    char *t93;
    char *t94;

LAB0:    t1 = (t0 + 5648U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(35, ng0);
    t2 = (t0 + 5984);
    *((int *)t2) = 1;
    t3 = (t0 + 5680);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(36, ng0);

LAB5:    xsi_set_current_line(37, ng0);
    t4 = (t0 + 1208U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(47, ng0);

LAB10:    xsi_set_current_line(48, ng0);
    t2 = (t0 + 1368U);
    t3 = *((char **)t2);
    memset(t14, 0, 8);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB11;

LAB12:    if (*((unsigned int *)t2) != 0)
        goto LAB13;

LAB14:    t5 = (t14 + 4);
    t15 = *((unsigned int *)t14);
    t16 = *((unsigned int *)t5);
    t17 = (t15 || t16);
    if (t17 > 0)
        goto LAB15;

LAB16:    t26 = *((unsigned int *)t14);
    t27 = (~(t26));
    t28 = *((unsigned int *)t5);
    t29 = (t27 || t28);
    if (t29 > 0)
        goto LAB17;

LAB18:    if (*((unsigned int *)t5) > 0)
        goto LAB19;

LAB20:    if (*((unsigned int *)t14) > 0)
        goto LAB21;

LAB22:    memcpy(t13, t31, 8);

LAB23:    t30 = (t0 + 3368);
    xsi_vlogvar_wait_assign_value(t30, t13, 0, 0, 8, 0LL);
    xsi_set_current_line(50, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(51, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3688);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(52, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3848);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(53, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4008);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(54, ng0);
    t2 = (t0 + 1528U);
    t3 = *((char **)t2);
    t2 = (t0 + 1688U);
    t4 = *((char **)t2);
    t6 = *((unsigned int *)t3);
    t7 = *((unsigned int *)t4);
    t8 = (t6 & t7);
    *((unsigned int *)t13) = t8;
    t2 = (t3 + 4);
    t5 = (t4 + 4);
    t11 = (t13 + 4);
    t9 = *((unsigned int *)t2);
    t10 = *((unsigned int *)t5);
    t15 = (t9 | t10);
    *((unsigned int *)t11) = t15;
    t16 = *((unsigned int *)t11);
    t17 = (t16 != 0);
    if (t17 == 1)
        goto LAB24;

LAB25:
LAB26:    t20 = (t0 + 1368U);
    t21 = *((char **)t20);
    memset(t14, 0, 8);
    t20 = (t21 + 4);
    t46 = *((unsigned int *)t20);
    t47 = (~(t46));
    t48 = *((unsigned int *)t21);
    t49 = (t48 & t47);
    t50 = (t49 & 1U);
    if (t50 != 0)
        goto LAB30;

LAB28:    if (*((unsigned int *)t20) == 0)
        goto LAB27;

LAB29:    t22 = (t14 + 4);
    *((unsigned int *)t14) = 1;
    *((unsigned int *)t22) = 1;

LAB30:    t23 = (t14 + 4);
    t24 = (t21 + 4);
    t51 = *((unsigned int *)t21);
    t52 = (~(t51));
    *((unsigned int *)t14) = t52;
    *((unsigned int *)t23) = 0;
    if (*((unsigned int *)t24) != 0)
        goto LAB32;

LAB31:    t57 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t57 & 1U);
    t58 = *((unsigned int *)t23);
    *((unsigned int *)t23) = (t58 & 1U);
    t59 = *((unsigned int *)t13);
    t60 = *((unsigned int *)t14);
    t61 = (t59 & t60);
    *((unsigned int *)t18) = t61;
    t25 = (t13 + 4);
    t30 = (t14 + 4);
    t31 = (t18 + 4);
    t62 = *((unsigned int *)t25);
    t63 = *((unsigned int *)t30);
    t64 = (t62 | t63);
    *((unsigned int *)t31) = t64;
    t65 = *((unsigned int *)t31);
    t66 = (t65 != 0);
    if (t66 == 1)
        goto LAB33;

LAB34:
LAB35:    t87 = (t18 + 4);
    t88 = *((unsigned int *)t87);
    t89 = (~(t88));
    t90 = *((unsigned int *)t18);
    t91 = (t90 & t89);
    t92 = (t91 != 0);
    if (t92 > 0)
        goto LAB36;

LAB37:
LAB38:    xsi_set_current_line(59, ng0);
    t2 = (t0 + 1528U);
    t3 = *((char **)t2);
    t2 = (t0 + 1848U);
    t4 = *((char **)t2);
    t6 = *((unsigned int *)t3);
    t7 = *((unsigned int *)t4);
    t8 = (t6 & t7);
    *((unsigned int *)t13) = t8;
    t2 = (t3 + 4);
    t5 = (t4 + 4);
    t11 = (t13 + 4);
    t9 = *((unsigned int *)t2);
    t10 = *((unsigned int *)t5);
    t15 = (t9 | t10);
    *((unsigned int *)t11) = t15;
    t16 = *((unsigned int *)t11);
    t17 = (t16 != 0);
    if (t17 == 1)
        goto LAB40;

LAB41:
LAB42:    t20 = (t0 + 1368U);
    t21 = *((char **)t20);
    memset(t14, 0, 8);
    t20 = (t21 + 4);
    t46 = *((unsigned int *)t20);
    t47 = (~(t46));
    t48 = *((unsigned int *)t21);
    t49 = (t48 & t47);
    t50 = (t49 & 1U);
    if (t50 != 0)
        goto LAB46;

LAB44:    if (*((unsigned int *)t20) == 0)
        goto LAB43;

LAB45:    t22 = (t14 + 4);
    *((unsigned int *)t14) = 1;
    *((unsigned int *)t22) = 1;

LAB46:    t23 = (t14 + 4);
    t24 = (t21 + 4);
    t51 = *((unsigned int *)t21);
    t52 = (~(t51));
    *((unsigned int *)t14) = t52;
    *((unsigned int *)t23) = 0;
    if (*((unsigned int *)t24) != 0)
        goto LAB48;

LAB47:    t57 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t57 & 1U);
    t58 = *((unsigned int *)t23);
    *((unsigned int *)t23) = (t58 & 1U);
    t59 = *((unsigned int *)t13);
    t60 = *((unsigned int *)t14);
    t61 = (t59 & t60);
    *((unsigned int *)t18) = t61;
    t25 = (t13 + 4);
    t30 = (t14 + 4);
    t31 = (t18 + 4);
    t62 = *((unsigned int *)t25);
    t63 = *((unsigned int *)t30);
    t64 = (t62 | t63);
    *((unsigned int *)t31) = t64;
    t65 = *((unsigned int *)t31);
    t66 = (t65 != 0);
    if (t66 == 1)
        goto LAB49;

LAB50:
LAB51:    t87 = (t18 + 4);
    t88 = *((unsigned int *)t87);
    t89 = (~(t88));
    t90 = *((unsigned int *)t18);
    t91 = (t90 & t89);
    t92 = (t91 != 0);
    if (t92 > 0)
        goto LAB52;

LAB53:
LAB54:    xsi_set_current_line(63, ng0);
    t2 = (t0 + 1528U);
    t3 = *((char **)t2);
    t2 = (t0 + 1688U);
    t4 = *((char **)t2);
    t6 = *((unsigned int *)t3);
    t7 = *((unsigned int *)t4);
    t8 = (t6 & t7);
    *((unsigned int *)t13) = t8;
    t2 = (t3 + 4);
    t5 = (t4 + 4);
    t11 = (t13 + 4);
    t9 = *((unsigned int *)t2);
    t10 = *((unsigned int *)t5);
    t15 = (t9 | t10);
    *((unsigned int *)t11) = t15;
    t16 = *((unsigned int *)t11);
    t17 = (t16 != 0);
    if (t17 == 1)
        goto LAB56;

LAB57:
LAB58:    t20 = (t0 + 1368U);
    t21 = *((char **)t20);
    t46 = *((unsigned int *)t13);
    t47 = *((unsigned int *)t21);
    t48 = (t46 & t47);
    *((unsigned int *)t14) = t48;
    t20 = (t13 + 4);
    t22 = (t21 + 4);
    t23 = (t14 + 4);
    t49 = *((unsigned int *)t20);
    t50 = *((unsigned int *)t22);
    t51 = (t49 | t50);
    *((unsigned int *)t23) = t51;
    t52 = *((unsigned int *)t23);
    t53 = (t52 != 0);
    if (t53 == 1)
        goto LAB59;

LAB60:
LAB61:    t30 = (t14 + 4);
    t72 = *((unsigned int *)t30);
    t73 = (~(t72));
    t74 = *((unsigned int *)t14);
    t75 = (t74 & t73);
    t76 = (t75 != 0);
    if (t76 > 0)
        goto LAB62;

LAB63:
LAB64:    xsi_set_current_line(76, ng0);
    t2 = (t0 + 2808U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB66;

LAB67:
LAB68:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(38, ng0);

LAB9:    xsi_set_current_line(39, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 1, 0LL);
    xsi_set_current_line(40, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3688);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(41, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3848);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(42, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4008);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(43, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4328);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(44, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3368);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 8, 0LL);
    goto LAB8;

LAB11:    *((unsigned int *)t14) = 1;
    goto LAB14;

LAB13:    t4 = (t14 + 4);
    *((unsigned int *)t14) = 1;
    *((unsigned int *)t4) = 1;
    goto LAB14;

LAB15:    t11 = ((char*)((ng1)));
    t12 = (t0 + 4168);
    t19 = (t12 + 56U);
    t20 = *((char **)t19);
    t21 = (t0 + 2648U);
    t22 = *((char **)t21);
    t21 = (t0 + 4328);
    t23 = (t21 + 56U);
    t24 = *((char **)t23);
    t25 = ((char*)((ng1)));
    xsi_vlogtype_concat(t18, 8, 8, 5U, t25, 1, t24, 1, t22, 1, t20, 1, t11, 4);
    goto LAB16;

LAB17:    t30 = (t0 + 2968U);
    t31 = *((char **)t30);
    goto LAB18;

LAB19:    xsi_vlog_unsigned_bit_combine(t13, 8, t18, 8, t31, 8);
    goto LAB23;

LAB21:    memcpy(t13, t18, 8);
    goto LAB23;

LAB24:    t26 = *((unsigned int *)t13);
    t27 = *((unsigned int *)t11);
    *((unsigned int *)t13) = (t26 | t27);
    t12 = (t3 + 4);
    t19 = (t4 + 4);
    t28 = *((unsigned int *)t3);
    t29 = (~(t28));
    t32 = *((unsigned int *)t12);
    t33 = (~(t32));
    t34 = *((unsigned int *)t4);
    t35 = (~(t34));
    t36 = *((unsigned int *)t19);
    t37 = (~(t36));
    t38 = (t29 & t33);
    t39 = (t35 & t37);
    t40 = (~(t38));
    t41 = (~(t39));
    t42 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t42 & t40);
    t43 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t43 & t41);
    t44 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t44 & t40);
    t45 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t45 & t41);
    goto LAB26;

LAB27:    *((unsigned int *)t14) = 1;
    goto LAB30;

LAB32:    t53 = *((unsigned int *)t14);
    t54 = *((unsigned int *)t24);
    *((unsigned int *)t14) = (t53 | t54);
    t55 = *((unsigned int *)t23);
    t56 = *((unsigned int *)t24);
    *((unsigned int *)t23) = (t55 | t56);
    goto LAB31;

LAB33:    t67 = *((unsigned int *)t18);
    t68 = *((unsigned int *)t31);
    *((unsigned int *)t18) = (t67 | t68);
    t69 = (t13 + 4);
    t70 = (t14 + 4);
    t71 = *((unsigned int *)t13);
    t72 = (~(t71));
    t73 = *((unsigned int *)t69);
    t74 = (~(t73));
    t75 = *((unsigned int *)t14);
    t76 = (~(t75));
    t77 = *((unsigned int *)t70);
    t78 = (~(t77));
    t79 = (t72 & t74);
    t80 = (t76 & t78);
    t81 = (~(t79));
    t82 = (~(t80));
    t83 = *((unsigned int *)t31);
    *((unsigned int *)t31) = (t83 & t81);
    t84 = *((unsigned int *)t31);
    *((unsigned int *)t31) = (t84 & t82);
    t85 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t85 & t81);
    t86 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t86 & t82);
    goto LAB35;

LAB36:    xsi_set_current_line(55, ng0);

LAB39:    xsi_set_current_line(56, ng0);
    t93 = (t0 + 2168U);
    t94 = *((char **)t93);
    t93 = (t0 + 4488);
    xsi_vlogvar_wait_assign_value(t93, t94, 0, 0, 8, 0LL);
    xsi_set_current_line(57, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4328);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB38;

LAB40:    t26 = *((unsigned int *)t13);
    t27 = *((unsigned int *)t11);
    *((unsigned int *)t13) = (t26 | t27);
    t12 = (t3 + 4);
    t19 = (t4 + 4);
    t28 = *((unsigned int *)t3);
    t29 = (~(t28));
    t32 = *((unsigned int *)t12);
    t33 = (~(t32));
    t34 = *((unsigned int *)t4);
    t35 = (~(t34));
    t36 = *((unsigned int *)t19);
    t37 = (~(t36));
    t38 = (t29 & t33);
    t39 = (t35 & t37);
    t40 = (~(t38));
    t41 = (~(t39));
    t42 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t42 & t40);
    t43 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t43 & t41);
    t44 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t44 & t40);
    t45 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t45 & t41);
    goto LAB42;

LAB43:    *((unsigned int *)t14) = 1;
    goto LAB46;

LAB48:    t53 = *((unsigned int *)t14);
    t54 = *((unsigned int *)t24);
    *((unsigned int *)t14) = (t53 | t54);
    t55 = *((unsigned int *)t23);
    t56 = *((unsigned int *)t24);
    *((unsigned int *)t23) = (t55 | t56);
    goto LAB47;

LAB49:    t67 = *((unsigned int *)t18);
    t68 = *((unsigned int *)t31);
    *((unsigned int *)t18) = (t67 | t68);
    t69 = (t13 + 4);
    t70 = (t14 + 4);
    t71 = *((unsigned int *)t13);
    t72 = (~(t71));
    t73 = *((unsigned int *)t69);
    t74 = (~(t73));
    t75 = *((unsigned int *)t14);
    t76 = (~(t75));
    t77 = *((unsigned int *)t70);
    t78 = (~(t77));
    t79 = (t72 & t74);
    t80 = (t76 & t78);
    t81 = (~(t79));
    t82 = (~(t80));
    t83 = *((unsigned int *)t31);
    *((unsigned int *)t31) = (t83 & t81);
    t84 = *((unsigned int *)t31);
    *((unsigned int *)t31) = (t84 & t82);
    t85 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t85 & t81);
    t86 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t86 & t82);
    goto LAB51;

LAB52:    xsi_set_current_line(60, ng0);

LAB55:    xsi_set_current_line(61, ng0);
    t93 = ((char*)((ng1)));
    t94 = (t0 + 4328);
    xsi_vlogvar_wait_assign_value(t94, t93, 0, 0, 1, 0LL);
    goto LAB54;

LAB56:    t26 = *((unsigned int *)t13);
    t27 = *((unsigned int *)t11);
    *((unsigned int *)t13) = (t26 | t27);
    t12 = (t3 + 4);
    t19 = (t4 + 4);
    t28 = *((unsigned int *)t3);
    t29 = (~(t28));
    t32 = *((unsigned int *)t12);
    t33 = (~(t32));
    t34 = *((unsigned int *)t4);
    t35 = (~(t34));
    t36 = *((unsigned int *)t19);
    t37 = (~(t36));
    t38 = (t29 & t33);
    t39 = (t35 & t37);
    t40 = (~(t38));
    t41 = (~(t39));
    t42 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t42 & t40);
    t43 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t43 & t41);
    t44 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t44 & t40);
    t45 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t45 & t41);
    goto LAB58;

LAB59:    t54 = *((unsigned int *)t14);
    t55 = *((unsigned int *)t23);
    *((unsigned int *)t14) = (t54 | t55);
    t24 = (t13 + 4);
    t25 = (t21 + 4);
    t56 = *((unsigned int *)t13);
    t57 = (~(t56));
    t58 = *((unsigned int *)t24);
    t59 = (~(t58));
    t60 = *((unsigned int *)t21);
    t61 = (~(t60));
    t62 = *((unsigned int *)t25);
    t63 = (~(t62));
    t79 = (t57 & t59);
    t80 = (t61 & t63);
    t64 = (~(t79));
    t65 = (~(t80));
    t66 = *((unsigned int *)t23);
    *((unsigned int *)t23) = (t66 & t64);
    t67 = *((unsigned int *)t23);
    *((unsigned int *)t23) = (t67 & t65);
    t68 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t68 & t64);
    t71 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t71 & t65);
    goto LAB61;

LAB62:    xsi_set_current_line(64, ng0);

LAB65:    xsi_set_current_line(65, ng0);
    t31 = (t0 + 2168U);
    t69 = *((char **)t31);
    memset(t18, 0, 8);
    t31 = (t18 + 4);
    t70 = (t69 + 4);
    t77 = *((unsigned int *)t69);
    t78 = (t77 >> 0);
    t81 = (t78 & 1);
    *((unsigned int *)t18) = t81;
    t82 = *((unsigned int *)t70);
    t83 = (t82 >> 0);
    t84 = (t83 & 1);
    *((unsigned int *)t31) = t84;
    t87 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t87, t18, 0, 0, 1, 0LL);
    xsi_set_current_line(66, ng0);
    t2 = (t0 + 2168U);
    t3 = *((char **)t2);
    memset(t13, 0, 8);
    t2 = (t13 + 4);
    t4 = (t3 + 4);
    t6 = *((unsigned int *)t3);
    t7 = (t6 >> 1);
    t8 = (t7 & 1);
    *((unsigned int *)t13) = t8;
    t9 = *((unsigned int *)t4);
    t10 = (t9 >> 1);
    t15 = (t10 & 1);
    *((unsigned int *)t2) = t15;
    t5 = (t0 + 3688);
    xsi_vlogvar_wait_assign_value(t5, t13, 0, 0, 1, 0LL);
    xsi_set_current_line(67, ng0);
    t2 = (t0 + 2168U);
    t3 = *((char **)t2);
    memset(t13, 0, 8);
    t2 = (t13 + 4);
    t4 = (t3 + 4);
    t6 = *((unsigned int *)t3);
    t7 = (t6 >> 2);
    t8 = (t7 & 1);
    *((unsigned int *)t13) = t8;
    t9 = *((unsigned int *)t4);
    t10 = (t9 >> 2);
    t15 = (t10 & 1);
    *((unsigned int *)t2) = t15;
    t5 = (t0 + 3848);
    xsi_vlogvar_wait_assign_value(t5, t13, 0, 0, 1, 0LL);
    xsi_set_current_line(68, ng0);
    t2 = (t0 + 2168U);
    t3 = *((char **)t2);
    memset(t13, 0, 8);
    t2 = (t13 + 4);
    t4 = (t3 + 4);
    t6 = *((unsigned int *)t3);
    t7 = (t6 >> 3);
    t8 = (t7 & 1);
    *((unsigned int *)t13) = t8;
    t9 = *((unsigned int *)t4);
    t10 = (t9 >> 3);
    t15 = (t10 & 1);
    *((unsigned int *)t2) = t15;
    t5 = (t0 + 4008);
    xsi_vlogvar_wait_assign_value(t5, t13, 0, 0, 1, 0LL);
    xsi_set_current_line(69, ng0);
    t2 = (t0 + 2168U);
    t3 = *((char **)t2);
    memset(t13, 0, 8);
    t2 = (t13 + 4);
    t4 = (t3 + 4);
    t6 = *((unsigned int *)t3);
    t7 = (t6 >> 4);
    t8 = (t7 & 1);
    *((unsigned int *)t13) = t8;
    t9 = *((unsigned int *)t4);
    t10 = (t9 >> 4);
    t15 = (t10 & 1);
    *((unsigned int *)t2) = t15;
    t5 = (t0 + 4168);
    xsi_vlogvar_wait_assign_value(t5, t13, 0, 0, 1, 0LL);
    xsi_set_current_line(70, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4328);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB64;

LAB66:    xsi_set_current_line(77, ng0);

LAB69:    xsi_set_current_line(78, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t0 + 4328);
    xsi_vlogvar_wait_assign_value(t5, t4, 0, 0, 1, 0LL);
    goto LAB68;

}


extern void work_m_06281157181617063034_3804827529_init()
{
	static char *pe[] = {(void *)Cont_33_0,(void *)Always_35_1};
	xsi_register_didat("work_m_06281157181617063034_3804827529", "isim/testbench_isim_beh.exe.sim/work/m_06281157181617063034_3804827529.didat");
	xsi_register_executes(pe);
}
