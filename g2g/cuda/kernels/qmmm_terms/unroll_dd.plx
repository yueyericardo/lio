#!/usr/bin/perl -w

print <<"END";
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   NOTE: THIS FILE WAS GENERATED AUTOMATICALLY     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

//-------------------------------------------BEGIN TERM-TYPE DEPENDENT PART (D-D)-------------------------------------------
        scalar_type F_mU[6];
        {
          scalar_type U = (PmC[0] * PmC[0] + PmC[1] * PmC[1] + PmC[2] * PmC[2]) * zeta;
          //F_mU[0] = (SQRT_PI / (2*sqrtU)) * erff(sqrtU);
          for (int m = 0; m <= 5; m++) 
          {
            // TODO (maybe): test out storing F(m,U) values in texture and doing a texture fetch here rather than the function calculation
            F_mU[m] = lio_gamma<scalar_type>(m,U);
            //F_mU[m] = fetch(qmmm_F_values_tex,(float)(U/gamma_inc-0.5f),(float)(m+0.5f));
          }
        }

        // BEGIN calculation of individual (single primitive-primitive overlap) force terms
        {
          C_force[0][tid] = 0.0f; C_force[1][tid] = 0.0f; C_force[2][tid] = 0.0f;
          scalar_type A_force_term, B_force_term, C_force_term;
          scalar_type AB_common;
          //scalar_type mm_charge = clatom_charge_sh[j];
          uint dens_ind = 0;

END
#          for (int d1_l1 = 0; d1_l1 < 3; d1_l1++)
for $d1_l1 (0..2) {
print <<"END";
          {
END
#            for (int d1_l2 = 0; d1_l2 <= d1_l1; d1_l2++)
for $d1_l2 (0..$d1_l1) {
print <<"END";
            {

              scalar_type d1_s0  = PmA[$d1_l1] * (PmA[$d1_l2] * F_mU[0] - PmC[$d1_l2] * F_mU[1]); // p_s0 (d1_l2)
              d1_s0             -= PmC[$d1_l1] * (PmA[$d1_l2] * F_mU[1] - PmC[$d1_l2] * F_mU[2]); // p_s1 (d1_l2)
              scalar_type d1_s1  = PmA[$d1_l1] * (PmA[$d1_l2] * F_mU[1] - PmC[$d1_l2] * F_mU[2]); // p_s1 (d1_l2)
              d1_s1             -= PmC[$d1_l1] * (PmA[$d1_l2] * F_mU[2] - PmC[$d1_l2] * F_mU[3]); // p_s2 (d1_l2)
              scalar_type d1_s2  = PmA[$d1_l1] * (PmA[$d1_l2] * F_mU[2] - PmC[$d1_l2] * F_mU[3]); // p_s2 (d1_l2)
              d1_s2             -= PmC[$d1_l1] * (PmA[$d1_l2] * F_mU[3] - PmC[$d1_l2] * F_mU[4]); // p_s3 (d1_l2)
              scalar_type d1_s3  = PmA[$d1_l1] * (PmA[$d1_l2] * F_mU[3] - PmC[$d1_l2] * F_mU[4]); // p_s2 (d1_l2)
              d1_s3             -= PmC[$d1_l1] * (PmA[$d1_l2] * F_mU[4] - PmC[$d1_l2] * F_mU[5]); // p_s3 (d1_l2)
END
if ($d1_l1 == $d1_l2) {
print <<"END";
              d1_s0             += inv_two_zeta * (F_mU[0] - F_mU[1]);
              d1_s1             += inv_two_zeta * (F_mU[1] - F_mU[2]);
              d1_s2             += inv_two_zeta * (F_mU[2] - F_mU[3]);
              d1_s3             += inv_two_zeta * (F_mU[3] - F_mU[4]);
END
}
#              for (int d2_l1 = 0; d2_l1 < 3; d2_l1++)
for $d2_l1 (0..2) {
print <<"END";
              {

                scalar_type p_p0_d1l1_d2l1  = PmB[$d2_l1] * (PmA[$d1_l1] * F_mU[0] - PmC[$d1_l1] * F_mU[1]); // p_s0 (d1_l1)
                p_p0_d1l1_d2l1             -= PmC[$d2_l1] * (PmA[$d1_l1] * F_mU[1] - PmC[$d1_l1] * F_mU[2]); // p_s1 (d1_l1)
                scalar_type p_p1_d1l1_d2l1  = PmB[$d2_l1] * (PmA[$d1_l1] * F_mU[1] - PmC[$d1_l1] * F_mU[2]); // p_s0 (d1_l1)
                p_p1_d1l1_d2l1             -= PmC[$d2_l1] * (PmA[$d1_l1] * F_mU[2] - PmC[$d1_l1] * F_mU[3]); // p_s1 (d1_l1)
                scalar_type p_p2_d1l1_d2l1  = PmB[$d2_l1] * (PmA[$d1_l1] * F_mU[2] - PmC[$d1_l1] * F_mU[3]); // p_s0 (d1_l1)
                p_p2_d1l1_d2l1             -= PmC[$d2_l1] * (PmA[$d1_l1] * F_mU[3] - PmC[$d1_l1] * F_mU[4]); // p_s1 (d1_l1)
END
if ($d1_l1 == $d2_l1) {
print <<"END";
                p_p0_d1l1_d2l1             += inv_two_zeta * (F_mU[0] - F_mU[1]);
                p_p1_d1l1_d2l1             += inv_two_zeta * (F_mU[1] - F_mU[2]);
                p_p2_d1l1_d2l1             += inv_two_zeta * (F_mU[2] - F_mU[3]);
END
}
print <<"END";
                scalar_type p_p0_d1l2_d2l1  = PmB[$d2_l1] * (PmA[$d1_l2] * F_mU[0] - PmC[$d1_l2] * F_mU[1]); // p_s0 (d1_l2)
                p_p0_d1l2_d2l1             -= PmC[$d2_l1] * (PmA[$d1_l2] * F_mU[1] - PmC[$d1_l2] * F_mU[2]); // p_s1 (d1_l2)
                scalar_type p_p1_d1l2_d2l1  = PmB[$d2_l1] * (PmA[$d1_l2] * F_mU[1] - PmC[$d1_l2] * F_mU[2]); // p_s0 (d1_l2)
                p_p1_d1l2_d2l1             -= PmC[$d2_l1] * (PmA[$d1_l2] * F_mU[2] - PmC[$d1_l2] * F_mU[3]); // p_s1 (d1_l2)
                scalar_type p_p2_d1l2_d2l1  = PmB[$d2_l1] * (PmA[$d1_l2] * F_mU[2] - PmC[$d1_l2] * F_mU[3]); // p_s0 (d1_l2)
                p_p2_d1l2_d2l1             -= PmC[$d2_l1] * (PmA[$d1_l2] * F_mU[3] - PmC[$d1_l2] * F_mU[4]); // p_s1 (d1_l2)
END
if ($d1_l2 == $d2_l1) {
print <<"END";
                p_p0_d1l2_d2l1             += inv_two_zeta * (F_mU[0] - F_mU[1]);
                p_p1_d1l2_d2l1             += inv_two_zeta * (F_mU[1] - F_mU[2]);
                p_p2_d1l2_d2l1             += inv_two_zeta * (F_mU[2] - F_mU[3]);
END
}
print <<"END";

                scalar_type d1_p0_d2l1 = 0.0f, d1_p1_d2l1 = 0.0f, d1_p2_d2l1 = 0.0f;
END
if ($d1_l1 == $d2_l1) {
print <<"END";
                d1_p0_d2l1  = (PmA[$d1_l2] * F_mU[0] - PmC[$d1_l2] * F_mU[1]) - (PmA[$d1_l2] * F_mU[1] - PmC[$d1_l2] * F_mU[2]);  // p_s0 (d1_l2) - p_s1 (d1_l2)
                d1_p1_d2l1  = (PmA[$d1_l2] * F_mU[1] - PmC[$d1_l2] * F_mU[2]) - (PmA[$d1_l2] * F_mU[2] - PmC[$d1_l2] * F_mU[3]);  // p_s0 (d1_l2) - p_s1 (d1_l2)
                d1_p2_d2l1  = (PmA[$d1_l2] * F_mU[2] - PmC[$d1_l2] * F_mU[3]) - (PmA[$d1_l2] * F_mU[3] - PmC[$d1_l2] * F_mU[4]);  // p_s0 (d1_l2) - p_s1 (d1_l2)
END
}
if ($d1_l2 == $d2_l1) {
print <<"END";
                d1_p0_d2l1 += (PmA[$d1_l1] * F_mU[0] - PmC[$d1_l1] * F_mU[1]) - (PmA[$d1_l1] * F_mU[1] - PmC[$d1_l1] * F_mU[2]);  // p_s0 (d1_l1) - p_s1 (d1_l1)
                d1_p1_d2l1 += (PmA[$d1_l1] * F_mU[1] - PmC[$d1_l1] * F_mU[2]) - (PmA[$d1_l1] * F_mU[2] - PmC[$d1_l1] * F_mU[3]);  // p_s0 (d1_l1) - p_s1 (d1_l1)
                d1_p2_d2l1 += (PmA[$d1_l1] * F_mU[2] - PmC[$d1_l1] * F_mU[3]) - (PmA[$d1_l1] * F_mU[3] - PmC[$d1_l1] * F_mU[4]);  // p_s0 (d1_l1) - p_s1 (d1_l1)
END
}
if ($d1_l1 == $d2_l1 or $d1_l2 == $d2_l1) {
print <<"END";
                d1_p0_d2l1 *= inv_two_zeta;
                d1_p1_d2l1 *= inv_two_zeta;
                d1_p2_d2l1 *= inv_two_zeta;
END
}
print <<"END";
                d1_p0_d2l1 += PmB[$d2_l1] * d1_s0 - PmC[$d2_l1] * d1_s1;
                d1_p1_d2l1 += PmB[$d2_l1] * d1_s1 - PmC[$d2_l1] * d1_s2;
                d1_p2_d2l1 += PmB[$d2_l1] * d1_s2 - PmC[$d2_l1] * d1_s3;
END
#                for (int d2_l2 = 0; d2_l2 <= d2_l1; d2_l2++)
for $d2_l2 (0..$d2_l1) {
print <<"END";
                {
                  scalar_type pre_term;
                  {
END
#                    bool skip = same_func && (d2_l1 > d1_l1 || (d2_l1 == d1_l1 && d2_l2 > d1_l2));
if ($d1_l1 != $d1_l2 and $d2_l1 != $d2_l2) {
print <<"END";
                    pre_term  = 1.0f;
END
} elsif ($d1_l1 != $d1_l2 or $d2_l1 != $d2_l2) {
print <<"END";
                    pre_term  = gpu_normalization_factor;
END
} else {
print <<"END";
                    pre_term  = gpu_normalization_factor * gpu_normalization_factor;
END
}
if ($d2_l1 > $d1_l1 or ($d2_l1 == $d1_l1 and $d2_l2 > $d1_l2)) {
print <<"END";
                    pre_term *= !same_func * clatom_charge_sh[j] * dens[dens_ind];
                    dens_ind += !same_func;
END
} else {
print <<"END";
                    pre_term *= clatom_charge_sh[j] * dens[dens_ind];
                    dens_ind++;
END
}
print <<"END";
                  }

                  scalar_type p_p0_d1l1_d2l2  = PmB[$d2_l2] * (PmA[$d1_l1] * F_mU[0] - PmC[$d1_l1] * F_mU[1]); // p_s0 (d1_l1)
                  p_p0_d1l1_d2l2             -= PmC[$d2_l2] * (PmA[$d1_l1] * F_mU[1] - PmC[$d1_l1] * F_mU[2]); // p_s1 (d1_l1)
                  scalar_type p_p1_d1l1_d2l2  = PmB[$d2_l2] * (PmA[$d1_l1] * F_mU[1] - PmC[$d1_l1] * F_mU[2]); // p_s0 (d1_l1)
                  p_p1_d1l1_d2l2             -= PmC[$d2_l2] * (PmA[$d1_l1] * F_mU[2] - PmC[$d1_l1] * F_mU[3]); // p_s1 (d1_l1)
                  scalar_type p_p2_d1l1_d2l2  = PmB[$d2_l2] * (PmA[$d1_l1] * F_mU[2] - PmC[$d1_l1] * F_mU[3]); // p_s0 (d1_l1)
                  p_p2_d1l1_d2l2             -= PmC[$d2_l2] * (PmA[$d1_l1] * F_mU[3] - PmC[$d1_l1] * F_mU[4]); // p_s1 (d1_l1)
END
if ($d1_l1 == $d2_l2) {
print <<"END";
                  p_p0_d1l1_d2l2             += inv_two_zeta * (F_mU[0] - F_mU[1]);
                  p_p1_d1l1_d2l2             += inv_two_zeta * (F_mU[1] - F_mU[2]);
                  p_p2_d1l1_d2l2             += inv_two_zeta * (F_mU[2] - F_mU[3]);
END
}
print <<"END";
                  scalar_type p_p0_d1l2_d2l2  = PmB[$d2_l2] * (PmA[$d1_l2] * F_mU[0] - PmC[$d1_l2] * F_mU[1]); // p_s0 (d1_l2)
                  p_p0_d1l2_d2l2             -= PmC[$d2_l2] * (PmA[$d1_l2] * F_mU[1] - PmC[$d1_l2] * F_mU[2]); // p_s1 (d1_l2)
                  scalar_type p_p1_d1l2_d2l2  = PmB[$d2_l2] * (PmA[$d1_l2] * F_mU[1] - PmC[$d1_l2] * F_mU[2]); // p_s0 (d1_l2)
                  p_p1_d1l2_d2l2             -= PmC[$d2_l2] * (PmA[$d1_l2] * F_mU[2] - PmC[$d1_l2] * F_mU[3]); // p_s1 (d1_l2)
                  scalar_type p_p2_d1l2_d2l2  = PmB[$d2_l2] * (PmA[$d1_l2] * F_mU[2] - PmC[$d1_l2] * F_mU[3]); // p_s0 (d1_l2)
                  p_p2_d1l2_d2l2             -= PmC[$d2_l2] * (PmA[$d1_l2] * F_mU[3] - PmC[$d1_l2] * F_mU[4]); // p_s1 (d1_l2)
END
if ($d1_l2 == $d2_l2) {
print <<"END";
                  p_p0_d1l2_d2l2             += inv_two_zeta * (F_mU[0] - F_mU[1]);
                  p_p1_d1l2_d2l2             += inv_two_zeta * (F_mU[1] - F_mU[2]);
                  p_p2_d1l2_d2l2             += inv_two_zeta * (F_mU[2] - F_mU[3]);
END
}
print <<"END";

                  scalar_type d1_p0_d2l2 = 0.0f, d1_p1_d2l2 = 0.0f, p_d2_0_d1l1 = 0.0f, p_d2_1_d1l1 = 0.0f, p_d2_0_d1l2 = 0.0f, p_d2_1_d1l2 = 0.0f;
END
if ($d1_l1 == $d2_l2) {
print <<"END";
                  d1_p0_d2l2   = (PmA[$d1_l2] * F_mU[0] - PmC[$d1_l2] * F_mU[1]) - (PmA[$d1_l2] * F_mU[1] - PmC[$d1_l2] * F_mU[2]);  // p_s0 (d1_l2) - p_s1 (d1_l2)
                  d1_p1_d2l2   = (PmA[$d1_l2] * F_mU[1] - PmC[$d1_l2] * F_mU[2]) - (PmA[$d1_l2] * F_mU[2] - PmC[$d1_l2] * F_mU[3]);  // p_s0 (d1_l2) - p_s1 (d1_l2)
                  p_d2_0_d1l1  = (PmB[$d2_l1] * F_mU[0] - PmC[$d2_l1] * F_mU[1]) - (PmB[$d2_l1] * F_mU[1] - PmC[$d2_l1] * F_mU[2]);  // p_s0 (d1_l2) - p_s1 (d1_l2)
                  p_d2_1_d1l1  = (PmB[$d2_l1] * F_mU[1] - PmC[$d2_l1] * F_mU[2]) - (PmB[$d2_l1] * F_mU[2] - PmC[$d2_l1] * F_mU[3]);  // p_s0 (d1_l2) - p_s1 (d1_l2)
END
}
if ($d1_l2 == $d2_l2) {
print <<"END";
                  d1_p0_d2l2  += (PmA[$d1_l1] * F_mU[0] - PmC[$d1_l1] * F_mU[1]) - (PmA[$d1_l1] * F_mU[1] - PmC[$d1_l1] * F_mU[2]);  // p_s0 (d1_l1) - p_s1 (d1_l1)
                  d1_p1_d2l2  += (PmA[$d1_l1] * F_mU[1] - PmC[$d1_l1] * F_mU[2]) - (PmA[$d1_l1] * F_mU[2] - PmC[$d1_l1] * F_mU[3]);  // p_s0 (d1_l1) - p_s1 (d1_l1)
                  p_d2_0_d1l2  = (PmB[$d2_l1] * F_mU[0] - PmC[$d2_l1] * F_mU[1]) - (PmB[$d2_l1] * F_mU[1] - PmC[$d2_l1] * F_mU[2]);  // p_s0 (d1_l2) - p_s1 (d1_l2)
                  p_d2_1_d1l2  = (PmB[$d2_l1] * F_mU[1] - PmC[$d2_l1] * F_mU[2]) - (PmB[$d2_l1] * F_mU[2] - PmC[$d2_l1] * F_mU[3]);  // p_s0 (d1_l2) - p_s1 (d1_l2)
END
}
if ($d1_l1 == $d2_l2 or $d1_l2 == $d2_l2) {
print <<"END";
                  d1_p0_d2l2  *= inv_two_zeta;
                  d1_p1_d2l2  *= inv_two_zeta;
END
}
print <<"END";
                  d1_p0_d2l2  += PmB[$d2_l2] * d1_s0 - PmC[$d2_l2] * d1_s1;
                  d1_p1_d2l2  += PmB[$d2_l2] * d1_s1 - PmC[$d2_l2] * d1_s2;
END
if ($d2_l1 == $d2_l2) {
print <<"END";
                  p_d2_0_d1l1 += (PmA[$d1_l1] * F_mU[0] - PmC[$d1_l1] * F_mU[1]) - (PmA[$d1_l1] * F_mU[1] - PmC[$d1_l1] * F_mU[2]);  // p_s0 (d1_l1) - p_s1 (d1_l1)
                  p_d2_1_d1l1 += (PmA[$d1_l1] * F_mU[1] - PmC[$d1_l1] * F_mU[2]) - (PmA[$d1_l1] * F_mU[2] - PmC[$d1_l1] * F_mU[3]);  // p_s0 (d1_l1) - p_s1 (d1_l1)
                  p_d2_0_d1l2 += (PmA[$d1_l2] * F_mU[0] - PmC[$d1_l2] * F_mU[1]) - (PmA[$d1_l2] * F_mU[1] - PmC[$d1_l2] * F_mU[2]);  // p_s0 (d1_l1) - p_s1 (d1_l1)
                  p_d2_1_d1l2 += (PmA[$d1_l2] * F_mU[1] - PmC[$d1_l2] * F_mU[2]) - (PmA[$d1_l2] * F_mU[2] - PmC[$d1_l2] * F_mU[3]);  // p_s0 (d1_l1) - p_s1 (d1_l1)
END
}
if ($d1_l1 == $d2_l2 or $d2_l1 == $d2_l2) {
print <<"END";
                  p_d2_0_d1l1 *= inv_two_zeta;
                  p_d2_1_d1l1 *= inv_two_zeta;
END
}
if ($d1_l2 == $d2_l2 or $d2_l1 == $d2_l2) {
print <<"END";
                  p_d2_0_d1l2 *= inv_two_zeta;
                  p_d2_1_d1l2 *= inv_two_zeta;
END
}
print <<"END";
                  p_d2_0_d1l1 += PmB[$d2_l2] * p_p0_d1l1_d2l1 - PmC[$d2_l2] * p_p1_d1l1_d2l1;
                  p_d2_1_d1l1 += PmB[$d2_l2] * p_p1_d1l1_d2l1 - PmC[$d2_l2] * p_p2_d1l1_d2l1;
                  p_d2_0_d1l2 += PmB[$d2_l2] * p_p0_d1l2_d2l1 - PmC[$d2_l2] * p_p1_d1l2_d2l1;
                  p_d2_1_d1l2 += PmB[$d2_l2] * p_p1_d1l2_d2l1 - PmC[$d2_l2] * p_p2_d1l2_d2l1;
END
print <<"END";

                  scalar_type d_d0 = 0.0f, d_d1 = 0.0f;
END
if ($d1_l1 == $d2_l2) {
print <<"END";
                  d_d0  = p_p0_d1l2_d2l1 - p_p1_d1l2_d2l1;
                  d_d1  = p_p1_d1l2_d2l1 - p_p2_d1l2_d2l1;
END
}
if ($d1_l2 == $d2_l2) {
print <<"END";
                  d_d0 += p_p0_d1l1_d2l1 - p_p1_d1l1_d2l1;
                  d_d1 += p_p1_d1l1_d2l1 - p_p2_d1l1_d2l1;
END
}
if ($d2_l1 == $d2_l2) {
print <<"END";
                  d_d0 += d1_s0 - d1_s1;
                  d_d1 += d1_s1 - d1_s2;
END
}
if ($d1_l1 == $d2_l2 or $d1_l2 == $d2_l2 or $d2_l1 == $d2_l2) {
print <<"END";
                  d_d0 *= inv_two_zeta;
                  d_d1 *= inv_two_zeta;
END
}
print <<"END";
                  d_d0 += PmB[$d2_l2] * d1_p0_d2l1 - PmC[$d2_l2] * d1_p1_d2l1;
                  d_d1 += PmB[$d2_l2] * d1_p1_d2l1 - PmC[$d2_l2] * d1_p2_d2l1;
END
#                  for (int grad_l = 0; grad_l < 3; grad_l++)
for $grad_l (0..2) {
print <<"END";
                  {
                    C_force_term  = 0.0f;
                    AB_common     = 0.0f;
END
if ($d1_l1 == $grad_l) {
print <<"END";
                    C_force_term  = p_d2_1_d1l2;
                    AB_common     = p_d2_0_d1l2;
END
}
if ($d1_l2 == $grad_l) {
print <<"END";
                    C_force_term += p_d2_1_d1l1;
                    AB_common    += p_d2_0_d1l1;
END
}
if ($d2_l1 == $grad_l) {
print <<"END";
                    C_force_term += d1_p1_d2l2;
                    AB_common    += d1_p0_d2l2;
END
}
if ($d2_l2 == $grad_l) {
print <<"END";
                    C_force_term += d1_p1_d2l1;
                    AB_common    += d1_p0_d2l1;
END
}
if ($d1_l1 == $grad_l or $d1_l2 == $grad_l or $d2_l1 == $grad_l or $d2_l2 == $grad_l) {
print <<"END";
                    C_force_term  = PmC[$grad_l] * d_d1 + inv_two_zeta * C_force_term; 

                    A_force_term  = inv_two_zeta * AB_common - C_force_term;
END
} else {
print <<"END";
                    C_force_term  = PmC[$grad_l] * d_d1;

                    A_force_term  = -C_force_term;
END
}
print <<"END";
                    B_force_term  = PmB[$grad_l] * d_d0 + A_force_term;
                    A_force_term += PmA[$grad_l] * d_d0;
                    A_force_term *= 2.0f * ai;
END
if ($d1_l1 == $grad_l) {
print <<"END";
                    A_force_term -= p_d2_0_d1l2;
END
}
if ($d1_l2 == $grad_l) {
print <<"END";
                    A_force_term -= p_d2_0_d1l1;
END
}
print <<"END";
                    B_force_term *= 2.0f * aj;
END
if ($d2_l1 == $grad_l) {
print <<"END";
                    B_force_term -= d1_p0_d2l2;
END
}
if ($d2_l2 == $grad_l) {
print <<"END";
                    B_force_term -= d1_p0_d2l1;
END
}
print <<"END";
                    A_force[$grad_l]     += pre_term * A_force_term;
                    B_force[$grad_l]     += pre_term * B_force_term;
                    C_force[$grad_l][tid]+= valid_thread * prefactor_mm * pre_term * C_force_term;
                  }
END
}
print <<"END";
                }
END
}
print <<"END";
              }
END
}
print <<"END";
            }
END
}
print <<"END";
          }
END
}
print <<"END";
        }
        // END individual force terms
//-------------------------------------------END TERM-TYPE DEPENDENT PART (D-D)-------------------------------------------
END
