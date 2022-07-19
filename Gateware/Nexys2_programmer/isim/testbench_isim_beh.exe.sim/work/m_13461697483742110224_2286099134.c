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
static const char *ng0 = "/home/ise/VM_share/Nexys2_programmer/Nexys2_hex_driver.v";
static unsigned int ng1[] = {0U, 0U};
static unsigned int ng2[] = {1U, 0U};
static unsigned int ng3[] = {2U, 0U};
static unsigned int ng4[] = {4U, 0U};
static unsigned int ng5[] = {3U, 0U};
static unsigned int ng6[] = {8U, 0U};



static void Always_37_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;

LAB0:    t1 = (t0 + 4920U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(37, ng0);
    t2 = (t0 + 5488);
    *((int *)t2) = 1;
    t3 = (t0 + 4952);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(38, ng0);

LAB5:    xsi_set_current_line(39, ng0);
    t4 = (t0 + 1208U);
    t5 = *((char **)t4);
    t4 = (t0 + 3368);
    xsi_vlogvar_wait_assign_value(t4, t5, 0, 0, 4, 0LL);
    xsi_set_current_line(40, ng0);
    t2 = (t0 + 1368U);
    t3 = *((char **)t2);
    t2 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 4, 0LL);
    xsi_set_current_line(41, ng0);
    t2 = (t0 + 1528U);
    t3 = *((char **)t2);
    t2 = (t0 + 3688);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 4, 0LL);
    xsi_set_current_line(42, ng0);
    t2 = (t0 + 1688U);
    t3 = *((char **)t2);
    t2 = (t0 + 3848);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 4, 0LL);
    xsi_set_current_line(43, ng0);
    t2 = (t0 + 1848U);
    t3 = *((char **)t2);
    t2 = (t0 + 4008);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 4, 0LL);
    goto LAB2;

}

static void Always_52_1(char *t0)
{
    char t7[8];
    char t20[8];
    char t21[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    int t6;
    char *t8;
    char *t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    char *t19;
    char *t22;
    char *t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    char *t27;
    char *t28;
    char *t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    char *t38;

LAB0:    t1 = (t0 + 5168U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(52, ng0);
    t2 = (t0 + 5504);
    *((int *)t2) = 1;
    t3 = (t0 + 5200);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(53, ng0);

LAB5:    xsi_set_current_line(54, ng0);
    t4 = (t0 + 2008U);
    t5 = *((char **)t4);

LAB6:    t4 = ((char*)((ng1)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 2, t4, 2);
    if (t6 == 1)
        goto LAB7;

LAB8:    t2 = ((char*)((ng2)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 2, t2, 2);
    if (t6 == 1)
        goto LAB9;

LAB10:    t2 = ((char*)((ng3)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 2, t2, 2);
    if (t6 == 1)
        goto LAB11;

LAB12:    t2 = ((char*)((ng5)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 2, t2, 2);
    if (t6 == 1)
        goto LAB13;

LAB14:
LAB15:    xsi_set_current_line(61, ng0);
    t2 = (t0 + 2008U);
    t3 = *((char **)t2);

LAB24:    t2 = ((char*)((ng1)));
    t6 = xsi_vlog_unsigned_case_compare(t3, 2, t2, 2);
    if (t6 == 1)
        goto LAB25;

LAB26:    t2 = ((char*)((ng2)));
    t6 = xsi_vlog_unsigned_case_compare(t3, 2, t2, 2);
    if (t6 == 1)
        goto LAB27;

LAB28:    t2 = ((char*)((ng3)));
    t6 = xsi_vlog_unsigned_case_compare(t3, 2, t2, 2);
    if (t6 == 1)
        goto LAB29;

LAB30:    t2 = ((char*)((ng5)));
    t6 = xsi_vlog_unsigned_case_compare(t3, 2, t2, 2);
    if (t6 == 1)
        goto LAB31;

LAB32:
LAB33:    goto LAB2;

LAB7:    xsi_set_current_line(55, ng0);
    t8 = ((char*)((ng2)));
    memset(t7, 0, 8);
    t9 = (t7 + 4);
    t10 = (t8 + 4);
    t11 = *((unsigned int *)t8);
    t12 = (~(t11));
    *((unsigned int *)t7) = t12;
    *((unsigned int *)t9) = 0;
    if (*((unsigned int *)t10) != 0)
        goto LAB17;

LAB16:    t17 = *((unsigned int *)t7);
    *((unsigned int *)t7) = (t17 & 15U);
    t18 = *((unsigned int *)t9);
    *((unsigned int *)t9) = (t18 & 15U);
    t19 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t19, t7, 0, 0, 4, 0LL);
    goto LAB15;

LAB9:    xsi_set_current_line(56, ng0);
    t3 = ((char*)((ng3)));
    memset(t7, 0, 8);
    t4 = (t7 + 4);
    t8 = (t3 + 4);
    t11 = *((unsigned int *)t3);
    t12 = (~(t11));
    *((unsigned int *)t7) = t12;
    *((unsigned int *)t4) = 0;
    if (*((unsigned int *)t8) != 0)
        goto LAB19;

LAB18:    t17 = *((unsigned int *)t7);
    *((unsigned int *)t7) = (t17 & 15U);
    t18 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t18 & 15U);
    t9 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t9, t7, 0, 0, 4, 0LL);
    goto LAB15;

LAB11:    xsi_set_current_line(57, ng0);
    t3 = ((char*)((ng4)));
    memset(t7, 0, 8);
    t4 = (t7 + 4);
    t8 = (t3 + 4);
    t11 = *((unsigned int *)t3);
    t12 = (~(t11));
    *((unsigned int *)t7) = t12;
    *((unsigned int *)t4) = 0;
    if (*((unsigned int *)t8) != 0)
        goto LAB21;

LAB20:    t17 = *((unsigned int *)t7);
    *((unsigned int *)t7) = (t17 & 15U);
    t18 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t18 & 15U);
    t9 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t9, t7, 0, 0, 4, 0LL);
    goto LAB15;

LAB13:    xsi_set_current_line(58, ng0);
    t3 = ((char*)((ng6)));
    memset(t7, 0, 8);
    t4 = (t7 + 4);
    t8 = (t3 + 4);
    t11 = *((unsigned int *)t3);
    t12 = (~(t11));
    *((unsigned int *)t7) = t12;
    *((unsigned int *)t4) = 0;
    if (*((unsigned int *)t8) != 0)
        goto LAB23;

LAB22:    t17 = *((unsigned int *)t7);
    *((unsigned int *)t7) = (t17 & 15U);
    t18 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t18 & 15U);
    t9 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t9, t7, 0, 0, 4, 0LL);
    goto LAB15;

LAB17:    t13 = *((unsigned int *)t7);
    t14 = *((unsigned int *)t10);
    *((unsigned int *)t7) = (t13 | t14);
    t15 = *((unsigned int *)t9);
    t16 = *((unsigned int *)t10);
    *((unsigned int *)t9) = (t15 | t16);
    goto LAB16;

LAB19:    t13 = *((unsigned int *)t7);
    t14 = *((unsigned int *)t8);
    *((unsigned int *)t7) = (t13 | t14);
    t15 = *((unsigned int *)t4);
    t16 = *((unsigned int *)t8);
    *((unsigned int *)t4) = (t15 | t16);
    goto LAB18;

LAB21:    t13 = *((unsigned int *)t7);
    t14 = *((unsigned int *)t8);
    *((unsigned int *)t7) = (t13 | t14);
    t15 = *((unsigned int *)t4);
    t16 = *((unsigned int *)t8);
    *((unsigned int *)t4) = (t15 | t16);
    goto LAB20;

LAB23:    t13 = *((unsigned int *)t7);
    t14 = *((unsigned int *)t8);
    *((unsigned int *)t7) = (t13 | t14);
    t15 = *((unsigned int *)t4);
    t16 = *((unsigned int *)t8);
    *((unsigned int *)t4) = (t15 | t16);
    goto LAB22;

LAB25:    xsi_set_current_line(62, ng0);
    t4 = (t0 + 2648U);
    t8 = *((char **)t4);
    t4 = (t0 + 4008);
    t9 = (t4 + 56U);
    t10 = *((char **)t9);
    memset(t21, 0, 8);
    t19 = (t21 + 4);
    t22 = (t10 + 4);
    t11 = *((unsigned int *)t10);
    t12 = (t11 >> 3);
    t13 = (t12 & 1);
    *((unsigned int *)t21) = t13;
    t14 = *((unsigned int *)t22);
    t15 = (t14 >> 3);
    t16 = (t15 & 1);
    *((unsigned int *)t19) = t16;
    memset(t20, 0, 8);
    t23 = (t21 + 4);
    t17 = *((unsigned int *)t23);
    t18 = (~(t17));
    t24 = *((unsigned int *)t21);
    t25 = (t24 & t18);
    t26 = (t25 & 1U);
    if (t26 != 0)
        goto LAB37;

LAB35:    if (*((unsigned int *)t23) == 0)
        goto LAB34;

LAB36:    t27 = (t20 + 4);
    *((unsigned int *)t20) = 1;
    *((unsigned int *)t27) = 1;

LAB37:    t28 = (t20 + 4);
    t29 = (t21 + 4);
    t30 = *((unsigned int *)t21);
    t31 = (~(t30));
    *((unsigned int *)t20) = t31;
    *((unsigned int *)t28) = 0;
    if (*((unsigned int *)t29) != 0)
        goto LAB39;

LAB38:    t36 = *((unsigned int *)t20);
    *((unsigned int *)t20) = (t36 & 1U);
    t37 = *((unsigned int *)t28);
    *((unsigned int *)t28) = (t37 & 1U);
    xsi_vlogtype_concat(t7, 8, 8, 2U, t20, 1, t8, 7);
    t38 = (t0 + 3208);
    xsi_vlogvar_wait_assign_value(t38, t7, 0, 0, 8, 0LL);
    goto LAB33;

LAB27:    xsi_set_current_line(63, ng0);
    t4 = (t0 + 2488U);
    t8 = *((char **)t4);
    t4 = (t0 + 4008);
    t9 = (t4 + 56U);
    t10 = *((char **)t9);
    memset(t21, 0, 8);
    t19 = (t21 + 4);
    t22 = (t10 + 4);
    t11 = *((unsigned int *)t10);
    t12 = (t11 >> 2);
    t13 = (t12 & 1);
    *((unsigned int *)t21) = t13;
    t14 = *((unsigned int *)t22);
    t15 = (t14 >> 2);
    t16 = (t15 & 1);
    *((unsigned int *)t19) = t16;
    memset(t20, 0, 8);
    t23 = (t21 + 4);
    t17 = *((unsigned int *)t23);
    t18 = (~(t17));
    t24 = *((unsigned int *)t21);
    t25 = (t24 & t18);
    t26 = (t25 & 1U);
    if (t26 != 0)
        goto LAB43;

LAB41:    if (*((unsigned int *)t23) == 0)
        goto LAB40;

LAB42:    t27 = (t20 + 4);
    *((unsigned int *)t20) = 1;
    *((unsigned int *)t27) = 1;

LAB43:    t28 = (t20 + 4);
    t29 = (t21 + 4);
    t30 = *((unsigned int *)t21);
    t31 = (~(t30));
    *((unsigned int *)t20) = t31;
    *((unsigned int *)t28) = 0;
    if (*((unsigned int *)t29) != 0)
        goto LAB45;

LAB44:    t36 = *((unsigned int *)t20);
    *((unsigned int *)t20) = (t36 & 1U);
    t37 = *((unsigned int *)t28);
    *((unsigned int *)t28) = (t37 & 1U);
    xsi_vlogtype_concat(t7, 8, 8, 2U, t20, 1, t8, 7);
    t38 = (t0 + 3208);
    xsi_vlogvar_wait_assign_value(t38, t7, 0, 0, 8, 0LL);
    goto LAB33;

LAB29:    xsi_set_current_line(64, ng0);
    t4 = (t0 + 2328U);
    t8 = *((char **)t4);
    t4 = (t0 + 4008);
    t9 = (t4 + 56U);
    t10 = *((char **)t9);
    memset(t21, 0, 8);
    t19 = (t21 + 4);
    t22 = (t10 + 4);
    t11 = *((unsigned int *)t10);
    t12 = (t11 >> 1);
    t13 = (t12 & 1);
    *((unsigned int *)t21) = t13;
    t14 = *((unsigned int *)t22);
    t15 = (t14 >> 1);
    t16 = (t15 & 1);
    *((unsigned int *)t19) = t16;
    memset(t20, 0, 8);
    t23 = (t21 + 4);
    t17 = *((unsigned int *)t23);
    t18 = (~(t17));
    t24 = *((unsigned int *)t21);
    t25 = (t24 & t18);
    t26 = (t25 & 1U);
    if (t26 != 0)
        goto LAB49;

LAB47:    if (*((unsigned int *)t23) == 0)
        goto LAB46;

LAB48:    t27 = (t20 + 4);
    *((unsigned int *)t20) = 1;
    *((unsigned int *)t27) = 1;

LAB49:    t28 = (t20 + 4);
    t29 = (t21 + 4);
    t30 = *((unsigned int *)t21);
    t31 = (~(t30));
    *((unsigned int *)t20) = t31;
    *((unsigned int *)t28) = 0;
    if (*((unsigned int *)t29) != 0)
        goto LAB51;

LAB50:    t36 = *((unsigned int *)t20);
    *((unsigned int *)t20) = (t36 & 1U);
    t37 = *((unsigned int *)t28);
    *((unsigned int *)t28) = (t37 & 1U);
    xsi_vlogtype_concat(t7, 8, 8, 2U, t20, 1, t8, 7);
    t38 = (t0 + 3208);
    xsi_vlogvar_wait_assign_value(t38, t7, 0, 0, 8, 0LL);
    goto LAB33;

LAB31:    xsi_set_current_line(65, ng0);
    t4 = (t0 + 2168U);
    t8 = *((char **)t4);
    t4 = (t0 + 4008);
    t9 = (t4 + 56U);
    t10 = *((char **)t9);
    memset(t21, 0, 8);
    t19 = (t21 + 4);
    t22 = (t10 + 4);
    t11 = *((unsigned int *)t10);
    t12 = (t11 >> 0);
    t13 = (t12 & 1);
    *((unsigned int *)t21) = t13;
    t14 = *((unsigned int *)t22);
    t15 = (t14 >> 0);
    t16 = (t15 & 1);
    *((unsigned int *)t19) = t16;
    memset(t20, 0, 8);
    t23 = (t21 + 4);
    t17 = *((unsigned int *)t23);
    t18 = (~(t17));
    t24 = *((unsigned int *)t21);
    t25 = (t24 & t18);
    t26 = (t25 & 1U);
    if (t26 != 0)
        goto LAB55;

LAB53:    if (*((unsigned int *)t23) == 0)
        goto LAB52;

LAB54:    t27 = (t20 + 4);
    *((unsigned int *)t20) = 1;
    *((unsigned int *)t27) = 1;

LAB55:    t28 = (t20 + 4);
    t29 = (t21 + 4);
    t30 = *((unsigned int *)t21);
    t31 = (~(t30));
    *((unsigned int *)t20) = t31;
    *((unsigned int *)t28) = 0;
    if (*((unsigned int *)t29) != 0)
        goto LAB57;

LAB56:    t36 = *((unsigned int *)t20);
    *((unsigned int *)t20) = (t36 & 1U);
    t37 = *((unsigned int *)t28);
    *((unsigned int *)t28) = (t37 & 1U);
    xsi_vlogtype_concat(t7, 8, 8, 2U, t20, 1, t8, 7);
    t38 = (t0 + 3208);
    xsi_vlogvar_wait_assign_value(t38, t7, 0, 0, 8, 0LL);
    goto LAB33;

LAB34:    *((unsigned int *)t20) = 1;
    goto LAB37;

LAB39:    t32 = *((unsigned int *)t20);
    t33 = *((unsigned int *)t29);
    *((unsigned int *)t20) = (t32 | t33);
    t34 = *((unsigned int *)t28);
    t35 = *((unsigned int *)t29);
    *((unsigned int *)t28) = (t34 | t35);
    goto LAB38;

LAB40:    *((unsigned int *)t20) = 1;
    goto LAB43;

LAB45:    t32 = *((unsigned int *)t20);
    t33 = *((unsigned int *)t29);
    *((unsigned int *)t20) = (t32 | t33);
    t34 = *((unsigned int *)t28);
    t35 = *((unsigned int *)t29);
    *((unsigned int *)t28) = (t34 | t35);
    goto LAB44;

LAB46:    *((unsigned int *)t20) = 1;
    goto LAB49;

LAB51:    t32 = *((unsigned int *)t20);
    t33 = *((unsigned int *)t29);
    *((unsigned int *)t20) = (t32 | t33);
    t34 = *((unsigned int *)t28);
    t35 = *((unsigned int *)t29);
    *((unsigned int *)t28) = (t34 | t35);
    goto LAB50;

LAB52:    *((unsigned int *)t20) = 1;
    goto LAB55;

LAB57:    t32 = *((unsigned int *)t20);
    t33 = *((unsigned int *)t29);
    *((unsigned int *)t20) = (t32 | t33);
    t34 = *((unsigned int *)t28);
    t35 = *((unsigned int *)t29);
    *((unsigned int *)t28) = (t34 | t35);
    goto LAB56;

}


extern void work_m_13461697483742110224_2286099134_init()
{
	static char *pe[] = {(void *)Always_37_0,(void *)Always_52_1};
	xsi_register_didat("work_m_13461697483742110224_2286099134", "isim/testbench_isim_beh.exe.sim/work/m_13461697483742110224_2286099134.didat");
	xsi_register_executes(pe);
}
