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
static const char *ng0 = "/home/ise/VM_share/Nexys2_PMOD_Programmer/SPI_ri.v";
static unsigned int ng1[] = {0U, 0U};
static unsigned int ng2[] = {255U, 0U};
static unsigned int ng3[] = {1U, 0U};
static unsigned int ng4[] = {2U, 0U};
static unsigned int ng5[] = {3U, 0U};



static void Cont_47_0(char *t0)
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

LAB0:    t1 = (t0 + 5880U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(47, ng0);
    t2 = (t0 + 2968U);
    t3 = *((char **)t2);
    t2 = (t0 + 6808);
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
    t16 = (t0 + 6696);
    *((int *)t16) = 1;

LAB1:    return;
}

static void Cont_48_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    unsigned int t16;
    unsigned int t17;
    char *t18;

LAB0:    t1 = (t0 + 6128U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(48, ng0);
    t2 = (t0 + 4648);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 6872);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memset(t9, 0, 8);
    t10 = 255U;
    t11 = t10;
    t12 = (t4 + 4);
    t13 = *((unsigned int *)t4);
    t10 = (t10 & t13);
    t14 = *((unsigned int *)t12);
    t11 = (t11 & t14);
    t15 = (t9 + 4);
    t16 = *((unsigned int *)t9);
    *((unsigned int *)t9) = (t16 | t10);
    t17 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t17 | t11);
    xsi_driver_vfirst_trans(t5, 0, 7);
    t18 = (t0 + 6712);
    *((int *)t18) = 1;

LAB1:    return;
}

static void Always_50_2(char *t0)
{
    char t14[8];
    char t22[8];
    char t29[8];
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
    int t13;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t30;
    char *t31;
    char *t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    char *t38;
    char *t39;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    int t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    char *t52;
    unsigned int t53;
    unsigned int t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    char *t58;
    char *t59;
    char *t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    unsigned int t66;
    unsigned int t67;
    unsigned int t68;
    char *t69;

LAB0:    t1 = (t0 + 6376U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(50, ng0);
    t2 = (t0 + 6728);
    *((int *)t2) = 1;
    t3 = (t0 + 6408);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(51, ng0);

LAB5:    xsi_set_current_line(52, ng0);
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

LAB7:    xsi_set_current_line(64, ng0);

LAB10:    xsi_set_current_line(66, ng0);
    t2 = (t0 + 1368U);
    t3 = *((char **)t2);

LAB11:    t2 = ((char*)((ng1)));
    t13 = xsi_vlog_unsigned_case_compare(t3, 2, t2, 2);
    if (t13 == 1)
        goto LAB12;

LAB13:    t2 = ((char*)((ng3)));
    t13 = xsi_vlog_unsigned_case_compare(t3, 2, t2, 2);
    if (t13 == 1)
        goto LAB14;

LAB15:    t2 = ((char*)((ng4)));
    t13 = xsi_vlog_unsigned_case_compare(t3, 2, t2, 2);
    if (t13 == 1)
        goto LAB16;

LAB17:    t2 = ((char*)((ng5)));
    t13 = xsi_vlog_unsigned_case_compare(t3, 2, t2, 2);
    if (t13 == 1)
        goto LAB18;

LAB19:
LAB20:    xsi_set_current_line(74, ng0);
    t2 = ((char*)((ng1)));
    t4 = (t0 + 4008);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(75, ng0);
    t2 = (t0 + 1528U);
    t4 = *((char **)t2);
    t2 = (t0 + 1688U);
    t5 = *((char **)t2);
    t6 = *((unsigned int *)t4);
    t7 = *((unsigned int *)t5);
    t8 = (t6 & t7);
    *((unsigned int *)t14) = t8;
    t2 = (t4 + 4);
    t11 = (t5 + 4);
    t12 = (t14 + 4);
    t9 = *((unsigned int *)t2);
    t10 = *((unsigned int *)t11);
    t33 = (t9 | t10);
    *((unsigned int *)t12) = t33;
    t34 = *((unsigned int *)t12);
    t35 = (t34 != 0);
    if (t35 == 1)
        goto LAB30;

LAB31:
LAB32:    t17 = (t14 + 4);
    t57 = *((unsigned int *)t17);
    t61 = (~(t57));
    t62 = *((unsigned int *)t14);
    t63 = (t62 & t61);
    t64 = (t63 != 0);
    if (t64 > 0)
        goto LAB33;

LAB34:
LAB35:    xsi_set_current_line(104, ng0);
    t2 = (t0 + 2808U);
    t5 = *((char **)t2);
    t2 = (t0 + 3688);
    t11 = (t2 + 56U);
    t12 = *((char **)t11);
    t6 = *((unsigned int *)t5);
    t7 = *((unsigned int *)t12);
    t8 = (t6 & t7);
    *((unsigned int *)t14) = t8;
    t15 = (t5 + 4);
    t16 = (t12 + 4);
    t17 = (t14 + 4);
    t9 = *((unsigned int *)t15);
    t10 = *((unsigned int *)t16);
    t33 = (t9 | t10);
    *((unsigned int *)t17) = t33;
    t34 = *((unsigned int *)t17);
    t35 = (t34 != 0);
    if (t35 == 1)
        goto LAB55;

LAB56:
LAB57:    t20 = (t14 + 4);
    t57 = *((unsigned int *)t20);
    t61 = (~(t57));
    t62 = *((unsigned int *)t14);
    t63 = (t62 & t61);
    t64 = (t63 != 0);
    if (t64 > 0)
        goto LAB58;

LAB59:
LAB60:    xsi_set_current_line(109, ng0);
    t2 = (t0 + 2968U);
    t5 = *((char **)t2);
    t2 = (t5 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB62;

LAB63:
LAB64:    xsi_set_current_line(114, ng0);
    t2 = (t0 + 2968U);
    t5 = *((char **)t2);
    t2 = (t5 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB66;

LAB67:
LAB68:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(53, ng0);

LAB9:    xsi_set_current_line(54, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 3688);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 1, 0LL);
    xsi_set_current_line(55, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3848);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(56, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4008);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(57, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4168);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 8, 0LL);
    xsi_set_current_line(58, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4328);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(59, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4488);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(60, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4648);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 8, 0LL);
    xsi_set_current_line(61, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 8, 0LL);
    goto LAB8;

LAB12:    xsi_set_current_line(67, ng0);
    t4 = (t0 + 4968);
    t5 = (t4 + 56U);
    t11 = *((char **)t5);
    t12 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 8, 0LL);
    goto LAB20;

LAB14:    xsi_set_current_line(68, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t0 + 4328);
    t11 = (t5 + 56U);
    t12 = *((char **)t11);
    t15 = (t0 + 4488);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    t18 = ((char*)((ng1)));
    t19 = (t0 + 3848);
    t20 = (t19 + 56U);
    t21 = *((char **)t20);
    t23 = (t0 + 3848);
    t24 = (t23 + 56U);
    t25 = *((char **)t24);
    t26 = (t0 + 4008);
    t27 = (t26 + 56U);
    t28 = *((char **)t27);
    t6 = *((unsigned int *)t25);
    t7 = *((unsigned int *)t28);
    t8 = (t6 | t7);
    *((unsigned int *)t29) = t8;
    t30 = (t25 + 4);
    t31 = (t28 + 4);
    t32 = (t29 + 4);
    t9 = *((unsigned int *)t30);
    t10 = *((unsigned int *)t31);
    t33 = (t9 | t10);
    *((unsigned int *)t32) = t33;
    t34 = *((unsigned int *)t32);
    t35 = (t34 != 0);
    if (t35 == 1)
        goto LAB21;

LAB22:
LAB23:    memset(t22, 0, 8);
    t52 = (t29 + 4);
    t53 = *((unsigned int *)t52);
    t54 = (~(t53));
    t55 = *((unsigned int *)t29);
    t56 = (t55 & t54);
    t57 = (t56 & 1U);
    if (t57 != 0)
        goto LAB27;

LAB25:    if (*((unsigned int *)t52) == 0)
        goto LAB24;

LAB26:    t58 = (t22 + 4);
    *((unsigned int *)t22) = 1;
    *((unsigned int *)t58) = 1;

LAB27:    t59 = (t22 + 4);
    t60 = (t29 + 4);
    t61 = *((unsigned int *)t29);
    t62 = (~(t61));
    *((unsigned int *)t22) = t62;
    *((unsigned int *)t59) = 0;
    if (*((unsigned int *)t60) != 0)
        goto LAB29;

LAB28:    t67 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t67 & 1U);
    t68 = *((unsigned int *)t59);
    *((unsigned int *)t59) = (t68 & 1U);
    xsi_vlogtype_concat(t14, 8, 8, 6U, t22, 1, t21, 1, t18, 3, t17, 1, t12, 1, t4, 1);
    t69 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t69, t14, 0, 0, 8, 0LL);
    goto LAB20;

LAB16:    xsi_set_current_line(69, ng0);
    t4 = (t0 + 4168);
    t5 = (t4 + 56U);
    t11 = *((char **)t5);
    t12 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 8, 0LL);
    goto LAB20;

LAB18:    xsi_set_current_line(70, ng0);
    t4 = (t0 + 4648);
    t5 = (t4 + 56U);
    t11 = *((char **)t5);
    t12 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 8, 0LL);
    goto LAB20;

LAB21:    t36 = *((unsigned int *)t29);
    t37 = *((unsigned int *)t32);
    *((unsigned int *)t29) = (t36 | t37);
    t38 = (t25 + 4);
    t39 = (t28 + 4);
    t40 = *((unsigned int *)t38);
    t41 = (~(t40));
    t42 = *((unsigned int *)t25);
    t43 = (t42 & t41);
    t44 = *((unsigned int *)t39);
    t45 = (~(t44));
    t46 = *((unsigned int *)t28);
    t47 = (t46 & t45);
    t48 = (~(t43));
    t49 = (~(t47));
    t50 = *((unsigned int *)t32);
    *((unsigned int *)t32) = (t50 & t48);
    t51 = *((unsigned int *)t32);
    *((unsigned int *)t32) = (t51 & t49);
    goto LAB23;

LAB24:    *((unsigned int *)t22) = 1;
    goto LAB27;

LAB29:    t63 = *((unsigned int *)t22);
    t64 = *((unsigned int *)t60);
    *((unsigned int *)t22) = (t63 | t64);
    t65 = *((unsigned int *)t59);
    t66 = *((unsigned int *)t60);
    *((unsigned int *)t59) = (t65 | t66);
    goto LAB28;

LAB30:    t36 = *((unsigned int *)t14);
    t37 = *((unsigned int *)t12);
    *((unsigned int *)t14) = (t36 | t37);
    t15 = (t4 + 4);
    t16 = (t5 + 4);
    t40 = *((unsigned int *)t4);
    t41 = (~(t40));
    t42 = *((unsigned int *)t15);
    t44 = (~(t42));
    t45 = *((unsigned int *)t5);
    t46 = (~(t45));
    t48 = *((unsigned int *)t16);
    t49 = (~(t48));
    t13 = (t41 & t44);
    t43 = (t46 & t49);
    t50 = (~(t13));
    t51 = (~(t43));
    t53 = *((unsigned int *)t12);
    *((unsigned int *)t12) = (t53 & t50);
    t54 = *((unsigned int *)t12);
    *((unsigned int *)t12) = (t54 & t51);
    t55 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t55 & t50);
    t56 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t56 & t51);
    goto LAB32;

LAB33:    xsi_set_current_line(76, ng0);

LAB36:    xsi_set_current_line(77, ng0);
    t18 = ((char*)((ng3)));
    t19 = (t0 + 4008);
    xsi_vlogvar_wait_assign_value(t19, t18, 0, 0, 1, 0LL);
    xsi_set_current_line(78, ng0);
    t2 = (t0 + 1368U);
    t4 = *((char **)t2);

LAB37:    t2 = ((char*)((ng1)));
    t13 = xsi_vlog_unsigned_case_compare(t4, 2, t2, 2);
    if (t13 == 1)
        goto LAB38;

LAB39:    t2 = ((char*)((ng3)));
    t13 = xsi_vlog_unsigned_case_compare(t4, 2, t2, 2);
    if (t13 == 1)
        goto LAB40;

LAB41:    t2 = ((char*)((ng4)));
    t13 = xsi_vlog_unsigned_case_compare(t4, 2, t2, 2);
    if (t13 == 1)
        goto LAB42;

LAB43:    t2 = ((char*)((ng5)));
    t13 = xsi_vlog_unsigned_case_compare(t4, 2, t2, 2);
    if (t13 == 1)
        goto LAB44;

LAB45:
LAB46:    goto LAB35;

LAB38:    xsi_set_current_line(80, ng0);

LAB47:    xsi_set_current_line(81, ng0);
    t5 = (t0 + 2008U);
    t11 = *((char **)t5);
    t5 = (t0 + 4808);
    xsi_vlogvar_wait_assign_value(t5, t11, 0, 0, 8, 0LL);
    goto LAB46;

LAB40:    xsi_set_current_line(84, ng0);

LAB48:    xsi_set_current_line(85, ng0);
    t5 = (t0 + 2008U);
    t11 = *((char **)t5);
    memset(t14, 0, 8);
    t5 = (t14 + 4);
    t12 = (t11 + 4);
    t6 = *((unsigned int *)t11);
    t7 = (t6 >> 0);
    t8 = (t7 & 1);
    *((unsigned int *)t14) = t8;
    t9 = *((unsigned int *)t12);
    t10 = (t9 >> 0);
    t33 = (t10 & 1);
    *((unsigned int *)t5) = t33;
    t15 = (t0 + 3688);
    xsi_vlogvar_wait_assign_value(t15, t14, 0, 0, 1, 0LL);
    xsi_set_current_line(86, ng0);
    t2 = (t0 + 2008U);
    t5 = *((char **)t2);
    memset(t14, 0, 8);
    t2 = (t14 + 4);
    t11 = (t5 + 4);
    t6 = *((unsigned int *)t5);
    t7 = (t6 >> 0);
    t8 = (t7 & 1);
    *((unsigned int *)t14) = t8;
    t9 = *((unsigned int *)t11);
    t10 = (t9 >> 0);
    t33 = (t10 & 1);
    *((unsigned int *)t2) = t33;
    t12 = (t0 + 3848);
    xsi_vlogvar_wait_assign_value(t12, t14, 0, 0, 1, 0LL);
    xsi_set_current_line(87, ng0);
    t2 = (t0 + 2008U);
    t5 = *((char **)t2);
    memset(t14, 0, 8);
    t2 = (t14 + 4);
    t11 = (t5 + 4);
    t6 = *((unsigned int *)t5);
    t7 = (t6 >> 5);
    t8 = (t7 & 1);
    *((unsigned int *)t14) = t8;
    t9 = *((unsigned int *)t11);
    t10 = (t9 >> 5);
    t33 = (t10 & 1);
    *((unsigned int *)t2) = t33;
    t12 = (t14 + 4);
    t34 = *((unsigned int *)t12);
    t35 = (~(t34));
    t36 = *((unsigned int *)t14);
    t37 = (t36 & t35);
    t40 = (t37 != 0);
    if (t40 > 0)
        goto LAB49;

LAB50:
LAB51:    goto LAB46;

LAB42:    xsi_set_current_line(94, ng0);

LAB53:    xsi_set_current_line(95, ng0);
    t5 = (t0 + 2008U);
    t11 = *((char **)t5);
    t5 = (t0 + 4168);
    xsi_vlogvar_wait_assign_value(t5, t11, 0, 0, 8, 0LL);
    goto LAB46;

LAB44:    xsi_set_current_line(98, ng0);

LAB54:    xsi_set_current_line(99, ng0);
    t5 = (t0 + 2008U);
    t11 = *((char **)t5);
    t5 = (t0 + 4648);
    xsi_vlogvar_wait_assign_value(t5, t11, 0, 0, 8, 0LL);
    goto LAB46;

LAB49:    xsi_set_current_line(88, ng0);

LAB52:    xsi_set_current_line(89, ng0);
    t15 = (t0 + 2008U);
    t16 = *((char **)t15);
    memset(t22, 0, 8);
    t15 = (t22 + 4);
    t17 = (t16 + 4);
    t41 = *((unsigned int *)t16);
    t42 = (t41 >> 1);
    t44 = (t42 & 1);
    *((unsigned int *)t22) = t44;
    t45 = *((unsigned int *)t17);
    t46 = (t45 >> 1);
    t48 = (t46 & 1);
    *((unsigned int *)t15) = t48;
    t18 = (t0 + 4328);
    xsi_vlogvar_wait_assign_value(t18, t22, 0, 0, 1, 0LL);
    xsi_set_current_line(90, ng0);
    t2 = (t0 + 2008U);
    t5 = *((char **)t2);
    memset(t14, 0, 8);
    t2 = (t14 + 4);
    t11 = (t5 + 4);
    t6 = *((unsigned int *)t5);
    t7 = (t6 >> 2);
    t8 = (t7 & 1);
    *((unsigned int *)t14) = t8;
    t9 = *((unsigned int *)t11);
    t10 = (t9 >> 2);
    t33 = (t10 & 1);
    *((unsigned int *)t2) = t33;
    t12 = (t0 + 4488);
    xsi_vlogvar_wait_assign_value(t12, t14, 0, 0, 1, 0LL);
    goto LAB51;

LAB55:    t36 = *((unsigned int *)t14);
    t37 = *((unsigned int *)t17);
    *((unsigned int *)t14) = (t36 | t37);
    t18 = (t5 + 4);
    t19 = (t12 + 4);
    t40 = *((unsigned int *)t5);
    t41 = (~(t40));
    t42 = *((unsigned int *)t18);
    t44 = (~(t42));
    t45 = *((unsigned int *)t12);
    t46 = (~(t45));
    t48 = *((unsigned int *)t19);
    t49 = (~(t48));
    t13 = (t41 & t44);
    t43 = (t46 & t49);
    t50 = (~(t13));
    t51 = (~(t43));
    t53 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t53 & t50);
    t54 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t54 & t51);
    t55 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t55 & t50);
    t56 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t56 & t51);
    goto LAB57;

LAB58:    xsi_set_current_line(105, ng0);

LAB61:    xsi_set_current_line(106, ng0);
    t21 = ((char*)((ng1)));
    t23 = (t0 + 3688);
    xsi_vlogvar_wait_assign_value(t23, t21, 0, 0, 1, 0LL);
    goto LAB60;

LAB62:    xsi_set_current_line(110, ng0);

LAB65:    xsi_set_current_line(111, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 3848);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 1, 0LL);
    goto LAB64;

LAB66:    xsi_set_current_line(115, ng0);

LAB69:    xsi_set_current_line(116, ng0);
    t11 = (t0 + 3128U);
    t12 = *((char **)t11);
    t11 = (t0 + 4968);
    xsi_vlogvar_wait_assign_value(t11, t12, 0, 0, 8, 0LL);
    goto LAB68;

}


extern void work_m_16035414180649256465_3435915837_init()
{
	static char *pe[] = {(void *)Cont_47_0,(void *)Cont_48_1,(void *)Always_50_2};
	xsi_register_didat("work_m_16035414180649256465_3435915837", "isim/testbench_isim_beh.exe.sim/work/m_16035414180649256465_3435915837.didat");
	xsi_register_executes(pe);
}
