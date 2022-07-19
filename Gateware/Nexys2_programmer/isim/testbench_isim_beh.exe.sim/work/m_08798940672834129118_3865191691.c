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
static const char *ng0 = "/home/ise/VM_share/Nexys2_programmer/UART.v";
static unsigned int ng1[] = {434U, 0U};
static unsigned int ng2[] = {1U, 0U};
static unsigned int ng3[] = {1023U, 0U};
static int ng4[] = {0, 0};
static unsigned int ng5[] = {217U, 0U};
static unsigned int ng6[] = {0U, 0U};



static void Cont_22_0(char *t0)
{
    char t6[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t7;
    char *t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    unsigned int t27;
    unsigned int t28;
    char *t29;
    unsigned int t30;
    unsigned int t31;
    char *t32;
    unsigned int t33;
    unsigned int t34;
    char *t35;

LAB0:    t1 = (t0 + 5080U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(22, ng0);
    t2 = (t0 + 3528);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng1)));
    memset(t6, 0, 8);
    t7 = (t4 + 4);
    t8 = (t5 + 4);
    t9 = *((unsigned int *)t4);
    t10 = *((unsigned int *)t5);
    t11 = (t9 ^ t10);
    t12 = *((unsigned int *)t7);
    t13 = *((unsigned int *)t8);
    t14 = (t12 ^ t13);
    t15 = (t11 | t14);
    t16 = *((unsigned int *)t7);
    t17 = *((unsigned int *)t8);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB7;

LAB4:    if (t18 != 0)
        goto LAB6;

LAB5:    *((unsigned int *)t6) = 1;

LAB7:    t22 = (t0 + 6520);
    t23 = (t22 + 56U);
    t24 = *((char **)t23);
    t25 = (t24 + 56U);
    t26 = *((char **)t25);
    memset(t26, 0, 8);
    t27 = 1U;
    t28 = t27;
    t29 = (t6 + 4);
    t30 = *((unsigned int *)t6);
    t27 = (t27 & t30);
    t31 = *((unsigned int *)t29);
    t28 = (t28 & t31);
    t32 = (t26 + 4);
    t33 = *((unsigned int *)t26);
    *((unsigned int *)t26) = (t33 | t27);
    t34 = *((unsigned int *)t32);
    *((unsigned int *)t32) = (t34 | t28);
    xsi_driver_vfirst_trans(t22, 0, 0);
    t35 = (t0 + 6392);
    *((int *)t35) = 1;

LAB1:    return;
LAB6:    t21 = (t6 + 4);
    *((unsigned int *)t6) = 1;
    *((unsigned int *)t21) = 1;
    goto LAB7;

}

static void Cont_23_1(char *t0)
{
    char t6[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t7;
    char *t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    unsigned int t27;
    unsigned int t28;
    char *t29;
    unsigned int t30;
    unsigned int t31;
    char *t32;
    unsigned int t33;
    unsigned int t34;
    char *t35;

LAB0:    t1 = (t0 + 5328U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(23, ng0);
    t2 = (t0 + 3048);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng1)));
    memset(t6, 0, 8);
    t7 = (t4 + 4);
    t8 = (t5 + 4);
    t9 = *((unsigned int *)t4);
    t10 = *((unsigned int *)t5);
    t11 = (t9 ^ t10);
    t12 = *((unsigned int *)t7);
    t13 = *((unsigned int *)t8);
    t14 = (t12 ^ t13);
    t15 = (t11 | t14);
    t16 = *((unsigned int *)t7);
    t17 = *((unsigned int *)t8);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB7;

LAB4:    if (t18 != 0)
        goto LAB6;

LAB5:    *((unsigned int *)t6) = 1;

LAB7:    t22 = (t0 + 6584);
    t23 = (t22 + 56U);
    t24 = *((char **)t23);
    t25 = (t24 + 56U);
    t26 = *((char **)t25);
    memset(t26, 0, 8);
    t27 = 1U;
    t28 = t27;
    t29 = (t6 + 4);
    t30 = *((unsigned int *)t6);
    t27 = (t27 & t30);
    t31 = *((unsigned int *)t29);
    t28 = (t28 & t31);
    t32 = (t26 + 4);
    t33 = *((unsigned int *)t26);
    *((unsigned int *)t26) = (t33 | t27);
    t34 = *((unsigned int *)t32);
    *((unsigned int *)t32) = (t34 | t28);
    xsi_driver_vfirst_trans(t22, 0, 0);
    t35 = (t0 + 6408);
    *((int *)t35) = 1;

LAB1:    return;
LAB6:    t21 = (t6 + 4);
    *((unsigned int *)t6) = 1;
    *((unsigned int *)t21) = 1;
    goto LAB7;

}

static void Cont_24_2(char *t0)
{
    char t5[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;
    unsigned int t25;
    unsigned int t26;
    char *t27;

LAB0:    t1 = (t0 + 5576U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(24, ng0);
    t2 = (t0 + 3688);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t5, 0, 8);
    t6 = (t5 + 4);
    t7 = (t4 + 4);
    t8 = *((unsigned int *)t4);
    t9 = (t8 >> 0);
    t10 = (t9 & 1);
    *((unsigned int *)t5) = t10;
    t11 = *((unsigned int *)t7);
    t12 = (t11 >> 0);
    t13 = (t12 & 1);
    *((unsigned int *)t6) = t13;
    t14 = (t0 + 6648);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    memset(t18, 0, 8);
    t19 = 1U;
    t20 = t19;
    t21 = (t5 + 4);
    t22 = *((unsigned int *)t5);
    t19 = (t19 & t22);
    t23 = *((unsigned int *)t21);
    t20 = (t20 & t23);
    t24 = (t18 + 4);
    t25 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t25 | t19);
    t26 = *((unsigned int *)t24);
    *((unsigned int *)t24) = (t26 | t20);
    xsi_driver_vfirst_trans(t14, 0, 0);
    t27 = (t0 + 6424);
    *((int *)t27) = 1;

LAB1:    return;
}

static void Initial_26_3(char *t0)
{
    char *t1;
    char *t2;

LAB0:    xsi_set_current_line(27, ng0);

LAB2:    xsi_set_current_line(28, ng0);
    t1 = ((char*)((ng2)));
    t2 = (t0 + 4008);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 1);
    xsi_set_current_line(29, ng0);
    t1 = ((char*)((ng3)));
    t2 = (t0 + 3208);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 10);

LAB1:    return;
}

static void Always_32_4(char *t0)
{
    char t20[8];
    char t21[8];
    char t35[8];
    char t75[8];
    char t76[8];
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
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    char *t18;
    char *t19;
    char *t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    char *t31;
    unsigned int t32;
    char *t33;
    char *t34;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    char *t39;
    char *t40;
    char *t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    unsigned int t47;
    unsigned int t48;
    char *t49;
    char *t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;
    int t59;
    int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    unsigned int t66;
    char *t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    char *t73;
    char *t74;
    unsigned int t77;
    unsigned int t78;
    unsigned int t79;
    unsigned int t80;
    unsigned int t81;
    unsigned int t82;
    unsigned int t83;
    char *t84;
    unsigned int t85;
    unsigned int t86;
    unsigned int t87;
    unsigned int t88;
    unsigned int t89;
    char *t90;
    char *t91;

LAB0:    t1 = (t0 + 6072U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(32, ng0);
    t2 = (t0 + 6440);
    *((int *)t2) = 1;
    t3 = (t0 + 6104);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(33, ng0);

LAB5:    xsi_set_current_line(34, ng0);
    t4 = (t0 + 1688U);
    t5 = *((char **)t4);
    t4 = (t0 + 4008);
    xsi_vlogvar_wait_assign_value(t4, t5, 0, 0, 1, 0LL);
    xsi_set_current_line(35, ng0);
    t2 = (t0 + 1368U);
    t3 = *((char **)t2);
    t2 = (t0 + 4168);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 1, 0LL);
    xsi_set_current_line(36, ng0);
    t2 = (t0 + 1208U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(49, ng0);

LAB10:    xsi_set_current_line(50, ng0);
    t2 = (t0 + 3368);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 4);
    t6 = *((unsigned int *)t5);
    t7 = (~(t6));
    t8 = *((unsigned int *)t4);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB11;

LAB12:    xsi_set_current_line(61, ng0);

LAB19:    xsi_set_current_line(62, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 9, 0LL);
    xsi_set_current_line(63, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3208);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 10, 0LL);

LAB13:    xsi_set_current_line(65, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t20, 0, 8);
    t5 = (t4 + 4);
    t6 = *((unsigned int *)t5);
    t7 = (~(t6));
    t8 = *((unsigned int *)t4);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB23;

LAB21:    if (*((unsigned int *)t5) == 0)
        goto LAB20;

LAB22:    t11 = (t20 + 4);
    *((unsigned int *)t20) = 1;
    *((unsigned int *)t11) = 1;

LAB23:    t12 = (t20 + 4);
    t18 = (t4 + 4);
    t13 = *((unsigned int *)t4);
    t14 = (~(t13));
    *((unsigned int *)t20) = t14;
    *((unsigned int *)t12) = 0;
    if (*((unsigned int *)t18) != 0)
        goto LAB25;

LAB24:    t24 = *((unsigned int *)t20);
    *((unsigned int *)t20) = (t24 & 1U);
    t25 = *((unsigned int *)t12);
    *((unsigned int *)t12) = (t25 & 1U);
    t19 = (t20 + 4);
    t26 = *((unsigned int *)t19);
    t27 = (~(t26));
    t28 = *((unsigned int *)t20);
    t29 = (t28 & t27);
    t30 = (t29 != 0);
    if (t30 > 0)
        goto LAB26;

LAB27:
LAB28:    xsi_set_current_line(67, ng0);
    t2 = (t0 + 3208);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t21, 0, 8);
    t5 = (t21 + 4);
    t11 = (t4 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 0);
    t8 = (t7 & 1);
    *((unsigned int *)t21) = t8;
    t9 = *((unsigned int *)t11);
    t10 = (t9 >> 0);
    t13 = (t10 & 1);
    *((unsigned int *)t5) = t13;
    memset(t20, 0, 8);
    t12 = (t21 + 4);
    t14 = *((unsigned int *)t12);
    t15 = (~(t14));
    t16 = *((unsigned int *)t21);
    t17 = (t16 & t15);
    t23 = (t17 & 1U);
    if (t23 != 0)
        goto LAB32;

LAB30:    if (*((unsigned int *)t12) == 0)
        goto LAB29;

LAB31:    t18 = (t20 + 4);
    *((unsigned int *)t20) = 1;
    *((unsigned int *)t18) = 1;

LAB32:    t19 = (t20 + 4);
    t22 = (t21 + 4);
    t24 = *((unsigned int *)t21);
    t25 = (~(t24));
    *((unsigned int *)t20) = t25;
    *((unsigned int *)t19) = 0;
    if (*((unsigned int *)t22) != 0)
        goto LAB34;

LAB33:    t30 = *((unsigned int *)t20);
    *((unsigned int *)t20) = (t30 & 1U);
    t32 = *((unsigned int *)t19);
    *((unsigned int *)t19) = (t32 & 1U);
    t31 = (t0 + 3368);
    t33 = (t31 + 56U);
    t34 = *((char **)t33);
    t36 = *((unsigned int *)t20);
    t37 = *((unsigned int *)t34);
    t38 = (t36 & t37);
    *((unsigned int *)t35) = t38;
    t39 = (t20 + 4);
    t40 = (t34 + 4);
    t41 = (t35 + 4);
    t42 = *((unsigned int *)t39);
    t43 = *((unsigned int *)t40);
    t44 = (t42 | t43);
    *((unsigned int *)t41) = t44;
    t45 = *((unsigned int *)t41);
    t46 = (t45 != 0);
    if (t46 == 1)
        goto LAB35;

LAB36:
LAB37:    t67 = (t35 + 4);
    t68 = *((unsigned int *)t67);
    t69 = (~(t68));
    t70 = *((unsigned int *)t35);
    t71 = (t70 & t69);
    t72 = (t71 != 0);
    if (t72 > 0)
        goto LAB38;

LAB39:    xsi_set_current_line(74, ng0);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);

LAB40:    xsi_set_current_line(76, ng0);
    t2 = (t0 + 3848);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 4);
    t6 = *((unsigned int *)t5);
    t7 = (~(t6));
    t8 = *((unsigned int *)t4);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB42;

LAB43:    xsi_set_current_line(87, ng0);

LAB50:    xsi_set_current_line(88, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 9, 0LL);
    xsi_set_current_line(89, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3688);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 10, 0LL);

LAB44:    xsi_set_current_line(91, ng0);
    t2 = (t0 + 1368U);
    t3 = *((char **)t2);
    t2 = (t0 + 4168);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    memset(t20, 0, 8);
    t11 = (t5 + 4);
    t6 = *((unsigned int *)t11);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB54;

LAB52:    if (*((unsigned int *)t11) == 0)
        goto LAB51;

LAB53:    t12 = (t20 + 4);
    *((unsigned int *)t20) = 1;
    *((unsigned int *)t12) = 1;

LAB54:    t18 = (t20 + 4);
    t19 = (t5 + 4);
    t13 = *((unsigned int *)t5);
    t14 = (~(t13));
    *((unsigned int *)t20) = t14;
    *((unsigned int *)t18) = 0;
    if (*((unsigned int *)t19) != 0)
        goto LAB56;

LAB55:    t24 = *((unsigned int *)t20);
    *((unsigned int *)t20) = (t24 & 1U);
    t25 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t25 & 1U);
    t26 = *((unsigned int *)t3);
    t27 = *((unsigned int *)t20);
    t28 = (t26 & t27);
    *((unsigned int *)t21) = t28;
    t22 = (t3 + 4);
    t31 = (t20 + 4);
    t33 = (t21 + 4);
    t29 = *((unsigned int *)t22);
    t30 = *((unsigned int *)t31);
    t32 = (t29 | t30);
    *((unsigned int *)t33) = t32;
    t36 = *((unsigned int *)t33);
    t37 = (t36 != 0);
    if (t37 == 1)
        goto LAB57;

LAB58:
LAB59:    t40 = (t21 + 4);
    t61 = *((unsigned int *)t40);
    t62 = (~(t61));
    t63 = *((unsigned int *)t21);
    t64 = (t63 & t62);
    t65 = (t64 != 0);
    if (t65 > 0)
        goto LAB60;

LAB61:
LAB62:    xsi_set_current_line(96, ng0);
    t2 = (t0 + 3688);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t20, 0, 8);
    t5 = (t20 + 4);
    t11 = (t4 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 1);
    *((unsigned int *)t20) = t7;
    t8 = *((unsigned int *)t11);
    t9 = (t8 >> 1);
    *((unsigned int *)t5) = t9;
    t10 = *((unsigned int *)t20);
    *((unsigned int *)t20) = (t10 & 511U);
    t13 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t13 & 511U);
    t12 = ((char*)((ng6)));
    memset(t21, 0, 8);
    t18 = (t20 + 4);
    t19 = (t12 + 4);
    t14 = *((unsigned int *)t20);
    t15 = *((unsigned int *)t12);
    t16 = (t14 ^ t15);
    t17 = *((unsigned int *)t18);
    t23 = *((unsigned int *)t19);
    t24 = (t17 ^ t23);
    t25 = (t16 | t24);
    t26 = *((unsigned int *)t18);
    t27 = *((unsigned int *)t19);
    t28 = (t26 | t27);
    t29 = (~(t28));
    t30 = (t25 & t29);
    if (t30 != 0)
        goto LAB67;

LAB64:    if (t28 != 0)
        goto LAB66;

LAB65:    *((unsigned int *)t21) = 1;

LAB67:    memset(t35, 0, 8);
    t31 = (t21 + 4);
    t32 = *((unsigned int *)t31);
    t36 = (~(t32));
    t37 = *((unsigned int *)t21);
    t38 = (t37 & t36);
    t42 = (t38 & 1U);
    if (t42 != 0)
        goto LAB68;

LAB69:    if (*((unsigned int *)t31) != 0)
        goto LAB70;

LAB71:    t34 = (t35 + 4);
    t43 = *((unsigned int *)t35);
    t44 = *((unsigned int *)t34);
    t45 = (t43 || t44);
    if (t45 > 0)
        goto LAB72;

LAB73:    memcpy(t76, t35, 8);

LAB74:    t84 = (t76 + 4);
    t85 = *((unsigned int *)t84);
    t86 = (~(t85));
    t87 = *((unsigned int *)t76);
    t88 = (t87 & t86);
    t89 = (t88 != 0);
    if (t89 > 0)
        goto LAB82;

LAB83:    xsi_set_current_line(103, ng0);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 2728);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);

LAB84:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(37, ng0);

LAB9:    xsi_set_current_line(38, ng0);
    t4 = ((char*)((ng4)));
    t5 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t5, t4, 0, 0, 9, 0LL);
    xsi_set_current_line(39, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3368);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(40, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3848);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(41, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 9, 0LL);
    xsi_set_current_line(42, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 2728);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(43, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(44, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 2568);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 8, 0LL);
    xsi_set_current_line(45, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3688);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 10, 0LL);
    xsi_set_current_line(46, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3208);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 10, 0LL);
    goto LAB8;

LAB11:    xsi_set_current_line(51, ng0);

LAB14:    xsi_set_current_line(52, ng0);
    t11 = (t0 + 2008U);
    t12 = *((char **)t11);
    t11 = (t12 + 4);
    t13 = *((unsigned int *)t11);
    t14 = (~(t13));
    t15 = *((unsigned int *)t12);
    t16 = (t15 & t14);
    t17 = (t16 != 0);
    if (t17 > 0)
        goto LAB15;

LAB16:    xsi_set_current_line(58, ng0);
    t2 = (t0 + 3048);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng2)));
    memset(t20, 0, 8);
    xsi_vlog_unsigned_add(t20, 9, t4, 9, t5, 9);
    t11 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t11, t20, 0, 0, 9, 0LL);

LAB17:    goto LAB13;

LAB15:    xsi_set_current_line(53, ng0);

LAB18:    xsi_set_current_line(54, ng0);
    t18 = ((char*)((ng4)));
    t19 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t19, t18, 0, 0, 9, 0LL);
    xsi_set_current_line(55, ng0);
    t2 = (t0 + 3208);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t21, 0, 8);
    t5 = (t21 + 4);
    t11 = (t4 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 1);
    *((unsigned int *)t21) = t7;
    t8 = *((unsigned int *)t11);
    t9 = (t8 >> 1);
    *((unsigned int *)t5) = t9;
    t10 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t10 & 511U);
    t13 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t13 & 511U);
    t12 = (t0 + 4008);
    t18 = (t12 + 56U);
    t19 = *((char **)t18);
    xsi_vlogtype_concat(t20, 10, 10, 2U, t19, 1, t21, 9);
    t22 = (t0 + 3208);
    xsi_vlogvar_wait_assign_value(t22, t20, 0, 0, 10, 0LL);
    goto LAB17;

LAB20:    *((unsigned int *)t20) = 1;
    goto LAB23;

LAB25:    t15 = *((unsigned int *)t20);
    t16 = *((unsigned int *)t18);
    *((unsigned int *)t20) = (t15 | t16);
    t17 = *((unsigned int *)t12);
    t23 = *((unsigned int *)t18);
    *((unsigned int *)t12) = (t17 | t23);
    goto LAB24;

LAB26:    xsi_set_current_line(66, ng0);
    t22 = ((char*)((ng2)));
    t31 = (t0 + 3368);
    xsi_vlogvar_wait_assign_value(t31, t22, 0, 0, 1, 0LL);
    goto LAB28;

LAB29:    *((unsigned int *)t20) = 1;
    goto LAB32;

LAB34:    t26 = *((unsigned int *)t20);
    t27 = *((unsigned int *)t22);
    *((unsigned int *)t20) = (t26 | t27);
    t28 = *((unsigned int *)t19);
    t29 = *((unsigned int *)t22);
    *((unsigned int *)t19) = (t28 | t29);
    goto LAB33;

LAB35:    t47 = *((unsigned int *)t35);
    t48 = *((unsigned int *)t41);
    *((unsigned int *)t35) = (t47 | t48);
    t49 = (t20 + 4);
    t50 = (t34 + 4);
    t51 = *((unsigned int *)t20);
    t52 = (~(t51));
    t53 = *((unsigned int *)t49);
    t54 = (~(t53));
    t55 = *((unsigned int *)t34);
    t56 = (~(t55));
    t57 = *((unsigned int *)t50);
    t58 = (~(t57));
    t59 = (t52 & t54);
    t60 = (t56 & t58);
    t61 = (~(t59));
    t62 = (~(t60));
    t63 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t63 & t61);
    t64 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t64 & t62);
    t65 = *((unsigned int *)t35);
    *((unsigned int *)t35) = (t65 & t61);
    t66 = *((unsigned int *)t35);
    *((unsigned int *)t35) = (t66 & t62);
    goto LAB37;

LAB38:    xsi_set_current_line(68, ng0);

LAB41:    xsi_set_current_line(69, ng0);
    t73 = ((char*)((ng6)));
    t74 = (t0 + 3368);
    xsi_vlogvar_wait_assign_value(t74, t73, 0, 0, 1, 0LL);
    xsi_set_current_line(70, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(71, ng0);
    t2 = (t0 + 3208);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t20, 0, 8);
    t5 = (t20 + 4);
    t11 = (t4 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 1);
    *((unsigned int *)t20) = t7;
    t8 = *((unsigned int *)t11);
    t9 = (t8 >> 1);
    *((unsigned int *)t5) = t9;
    t10 = *((unsigned int *)t20);
    *((unsigned int *)t20) = (t10 & 255U);
    t13 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t13 & 255U);
    t12 = (t0 + 2568);
    xsi_vlogvar_wait_assign_value(t12, t20, 0, 0, 8, 0LL);
    goto LAB40;

LAB42:    xsi_set_current_line(77, ng0);

LAB45:    xsi_set_current_line(78, ng0);
    t11 = (t0 + 2168U);
    t12 = *((char **)t11);
    t11 = (t12 + 4);
    t13 = *((unsigned int *)t11);
    t14 = (~(t13));
    t15 = *((unsigned int *)t12);
    t16 = (t15 & t14);
    t17 = (t16 != 0);
    if (t17 > 0)
        goto LAB46;

LAB47:    xsi_set_current_line(84, ng0);
    t2 = (t0 + 3528);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng2)));
    memset(t20, 0, 8);
    xsi_vlog_unsigned_add(t20, 9, t4, 9, t5, 9);
    t11 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t11, t20, 0, 0, 9, 0LL);

LAB48:    goto LAB44;

LAB46:    xsi_set_current_line(79, ng0);

LAB49:    xsi_set_current_line(80, ng0);
    t18 = ((char*)((ng4)));
    t19 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t19, t18, 0, 0, 9, 0LL);
    xsi_set_current_line(81, ng0);
    t2 = (t0 + 3688);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t21, 0, 8);
    t5 = (t21 + 4);
    t11 = (t4 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 1);
    *((unsigned int *)t21) = t7;
    t8 = *((unsigned int *)t11);
    t9 = (t8 >> 1);
    *((unsigned int *)t5) = t9;
    t10 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t10 & 511U);
    t13 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t13 & 511U);
    t12 = ((char*)((ng6)));
    xsi_vlogtype_concat(t20, 10, 10, 2U, t12, 1, t21, 9);
    t18 = (t0 + 3688);
    xsi_vlogvar_wait_assign_value(t18, t20, 0, 0, 10, 0LL);
    goto LAB48;

LAB51:    *((unsigned int *)t20) = 1;
    goto LAB54;

LAB56:    t15 = *((unsigned int *)t20);
    t16 = *((unsigned int *)t19);
    *((unsigned int *)t20) = (t15 | t16);
    t17 = *((unsigned int *)t18);
    t23 = *((unsigned int *)t19);
    *((unsigned int *)t18) = (t17 | t23);
    goto LAB55;

LAB57:    t38 = *((unsigned int *)t21);
    t42 = *((unsigned int *)t33);
    *((unsigned int *)t21) = (t38 | t42);
    t34 = (t3 + 4);
    t39 = (t20 + 4);
    t43 = *((unsigned int *)t3);
    t44 = (~(t43));
    t45 = *((unsigned int *)t34);
    t46 = (~(t45));
    t47 = *((unsigned int *)t20);
    t48 = (~(t47));
    t51 = *((unsigned int *)t39);
    t52 = (~(t51));
    t59 = (t44 & t46);
    t60 = (t48 & t52);
    t53 = (~(t59));
    t54 = (~(t60));
    t55 = *((unsigned int *)t33);
    *((unsigned int *)t33) = (t55 & t53);
    t56 = *((unsigned int *)t33);
    *((unsigned int *)t33) = (t56 & t54);
    t57 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t57 & t53);
    t58 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t58 & t54);
    goto LAB59;

LAB60:    xsi_set_current_line(92, ng0);

LAB63:    xsi_set_current_line(93, ng0);
    t41 = ((char*)((ng2)));
    t49 = (t0 + 3848);
    xsi_vlogvar_wait_assign_value(t49, t41, 0, 0, 1, 0LL);
    xsi_set_current_line(94, ng0);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 1528U);
    t4 = *((char **)t3);
    t3 = ((char*)((ng2)));
    xsi_vlogtype_concat(t20, 10, 10, 3U, t3, 1, t4, 8, t2, 1);
    t5 = (t0 + 3688);
    xsi_vlogvar_wait_assign_value(t5, t20, 0, 0, 10, 0LL);
    goto LAB62;

LAB66:    t22 = (t21 + 4);
    *((unsigned int *)t21) = 1;
    *((unsigned int *)t22) = 1;
    goto LAB67;

LAB68:    *((unsigned int *)t35) = 1;
    goto LAB71;

LAB70:    t33 = (t35 + 4);
    *((unsigned int *)t35) = 1;
    *((unsigned int *)t33) = 1;
    goto LAB71;

LAB72:    t39 = (t0 + 2168U);
    t40 = *((char **)t39);
    memset(t75, 0, 8);
    t39 = (t40 + 4);
    t46 = *((unsigned int *)t39);
    t47 = (~(t46));
    t48 = *((unsigned int *)t40);
    t51 = (t48 & t47);
    t52 = (t51 & 1U);
    if (t52 != 0)
        goto LAB75;

LAB76:    if (*((unsigned int *)t39) != 0)
        goto LAB77;

LAB78:    t53 = *((unsigned int *)t35);
    t54 = *((unsigned int *)t75);
    t55 = (t53 & t54);
    *((unsigned int *)t76) = t55;
    t49 = (t35 + 4);
    t50 = (t75 + 4);
    t67 = (t76 + 4);
    t56 = *((unsigned int *)t49);
    t57 = *((unsigned int *)t50);
    t58 = (t56 | t57);
    *((unsigned int *)t67) = t58;
    t61 = *((unsigned int *)t67);
    t62 = (t61 != 0);
    if (t62 == 1)
        goto LAB79;

LAB80:
LAB81:    goto LAB74;

LAB75:    *((unsigned int *)t75) = 1;
    goto LAB78;

LAB77:    t41 = (t75 + 4);
    *((unsigned int *)t75) = 1;
    *((unsigned int *)t41) = 1;
    goto LAB78;

LAB79:    t63 = *((unsigned int *)t76);
    t64 = *((unsigned int *)t67);
    *((unsigned int *)t76) = (t63 | t64);
    t73 = (t35 + 4);
    t74 = (t75 + 4);
    t65 = *((unsigned int *)t35);
    t66 = (~(t65));
    t68 = *((unsigned int *)t73);
    t69 = (~(t68));
    t70 = *((unsigned int *)t75);
    t71 = (~(t70));
    t72 = *((unsigned int *)t74);
    t77 = (~(t72));
    t59 = (t66 & t69);
    t60 = (t71 & t77);
    t78 = (~(t59));
    t79 = (~(t60));
    t80 = *((unsigned int *)t67);
    *((unsigned int *)t67) = (t80 & t78);
    t81 = *((unsigned int *)t67);
    *((unsigned int *)t67) = (t81 & t79);
    t82 = *((unsigned int *)t76);
    *((unsigned int *)t76) = (t82 & t78);
    t83 = *((unsigned int *)t76);
    *((unsigned int *)t76) = (t83 & t79);
    goto LAB81;

LAB82:    xsi_set_current_line(97, ng0);

LAB85:    xsi_set_current_line(98, ng0);
    t90 = ((char*)((ng6)));
    t91 = (t0 + 3848);
    xsi_vlogvar_wait_assign_value(t91, t90, 0, 0, 1, 0LL);
    xsi_set_current_line(99, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3688);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 10, 0LL);
    xsi_set_current_line(100, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2728);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB84;

}


extern void work_m_08798940672834129118_3865191691_init()
{
	static char *pe[] = {(void *)Cont_22_0,(void *)Cont_23_1,(void *)Cont_24_2,(void *)Initial_26_3,(void *)Always_32_4};
	xsi_register_didat("work_m_08798940672834129118_3865191691", "isim/testbench_isim_beh.exe.sim/work/m_08798940672834129118_3865191691.didat");
	xsi_register_executes(pe);
}
