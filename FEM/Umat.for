! **********************************************************************
! *************Define the source term for protein spreading*************
! **********************************************************************
      SUBROUTINE HETVAL(CMNAME,TEMP,TIME,DTIME,STATEV,FLUX,
     1 PREDEF,DPRED)
C
      INCLUDE 'ABA_PARAM.INC'
C
      CHARACTER*80 CMNAME
C
      DIMENSION TEMP(2),STATEV(3),PREDEF(3),TIME(2),FLUX(2),
     1 DPRED(3)


      REAL*8 Alpha,Factor
      PARAMETER(Alpha = 0.9D0, Factor = 1.D0)
      FLUX(1) = Factor * Alpha * Temp(1)*(1-Temp(1))
      FLUX(2) = Factor * Alpha * (1-2.D0*Temp(1))


      RETURN
      END

!***********************************************************************
      SUBROUTINE UMATHT(U,DUDT,DUDG,FLUX,DFDT,DFDG,
     1 STATEV,TEMP,DTEMP,DTEMDX,TIME,DTIME,PREDEF,DPRED,
     2 CMNAME,NTGRD,NSTATV,PROPS,NPROPS,COORDS,PNEWDT,
     3 NOEL,NPT,LAYER,KSPT,KSTEP,KINC)
C
      INCLUDE 'ABA_PARAM.INC'
C
      CHARACTER*80 CMNAME

      INTEGER NOEL,NPT,LAYER,KSPT,KSTEP,KINC,NTGRD,NSTATV,NPROPS
C
      DIMENSION DUDG(NTGRD),FLUX(NTGRD),DFDT(NTGRD),
     1 DFDG(NTGRD,NTGRD),STATEV(NSTATV),DTEMDX(NTGRD),
     2 TIME(2),PREDEF(1),DPRED(1),PROPS(NPROPS),COORDS(3)
C
      REAL*8 Identity(3,3), COND_Matrix(3,3), SPECHT
C
      Identity(3,3) = 0.0D0
      DO I = 1, 3
        Identity(I,I) = 1.0D0
      END DO
C
      ! Material properties
      COND_Matrix = 0.0D0
      IF (NPROPS .EQ. 3) THEN
        ! Isotropic diffusion
        COND_Matrix  = PROPS(1) * Identity
        SPECHT       = PROPS(2)       ! Specific heat
      ELSE IF (NPROPS .EQ. 5) THEN
        ! Orthotropic diffusion
        COND_Matrix(1,1) = PROPS(1)       ! Thermal conductivity in x direction
        COND_Matrix(2,2) = PROPS(2)       !                      in y direction
        COND_Matrix(3,3) = PROPS(3)       !                      in z direction
        SPECHT           = PROPS(4)       ! Specific heat
      END IF
C
      ! Calculate internal energy change
      DUDT = SPECHT
      DU = DUDT*DTEMP
      U = U+DU
C
      ! Calculate the term related to the diffusion
      DFDT = 0.0D0
      DFDG = 0.0D0
      DO I=1, NTGRD
            FLUX(I)   = - COND_Matrix(I,I)*DTEMDX(I)
            DFDG(I,I) = - COND_Matrix(I,I)
      END DO
C
      RETURN
      END

      SUBROUTINE UMAT(STRESS,STATEV,DDSDDE,SSE,SPD,SCD,
     1 RPL,DDSDDT,DRPLDE,DRPLDT,
     2 STRAN,DSTRAN,TIME,DTIME,TEMP,DTEMP,PREDEF,DPRED,CMNAME,
     3 NDI,NSHR,NTENS,NSTATV,PROPS,NPROPS,COORDS,DROT,PNEWDT,
     4 CELENT,DFGRD0,DFGRD1,NOEL,NPT,LAYER,KSPT,JSTEP,KINC)
C
      INCLUDE 'ABA_PARAM.INC'
C
      CHARACTER*80 CMNAME
      DIMENSION STRESS(NTENS),STATEV(NSTATV),
     1 DDSDDE(NTENS,NTENS),DDSDDT(NTENS),DRPLDE(NTENS),
     2 STRAN(NTENS),DSTRAN(NTENS),TIME(2),PREDEF(2),DPRED(2),
     3 PROPS(NPROPS),COORDS(3),DROT(3,3),DFGRD0(3,3),DFGRD1(3,3),
     4 JSTEP(4)

        REAL*8 mu, lambda, F_tau(3,3), detF_tau, B(3,3), Sigma_Cauchy(3,3)
        REAL*8 Identity(3,3), C_mat(3,3,3,3)
        INTEGER I, J, K, L
        REAL*8 var_theta, var_theta_inc, F_e(3,3), detF_e
        REAL*8 G_0, G_c, MatType, OriVector(3), OriMatrix(3,3), F_a(3,3), inv_F_a(3,3)

        REAL*8 Atrophy_rate, Critical_C
        REAL*8 var_theta_aging, var_theta_protein
        ! *********************************************************************
        ! If MatType = 1, then the material is white matter
        ! If MatType = 0, then the material is grey matter
        ! MatType = PREDEF(2)
        ! mu     = PROPS(1)*MatType + PROPS(3)*( 1.0D0 - MatType ) ! Shear modulus
        ! lambda = PROPS(2)*MatType + PROPS(4)*( 1.0D0 - MatType ) ! Bulk modulus
        mu           = PROPS(1) ! Shear modulus
        lambda       = PROPS(2) ! Bulk modulus
        MatType      = PROPS(3)
        G_0          = PROPS(4)
        Atrophy_rate = PROPS(5)
        Critical_C   = PROPS(6)

        OriVector(1) = 0.0D0
        OriVector(2) = 1.0D0
        OriVector(3) = 0.0D0
        Identity = 0.0D0
        DO I = 1, 3
            Identity(I,I) = 1.0D0
        END DO


        ! *********************************************************************
        ! Compute the increment of the atrophy variable
        IF (KINC .LE. 1) THEN
          var_theta         = 1.0
          var_theta_aging   = 0.0D0
          var_theta_protein = 0.0D0
          STATEV(5)         = 0.0D0
        ELSE
          var_theta         = STATEV(1)
          var_theta_aging   = STATEV(2)
          var_theta_protein = STATEV(3)
        END IF
        ! -----------------------------------------------------------------------
        ! Ageing induced atrophy
        var_theta_aging = var_theta_aging + G_0 * DTIME
        ! -----------------------------------------------------------------------
        ! Chemical induced atrophy
        IF (TEMP .GT. Critical_C) THEN
          var_theta_protein = var_theta_protein + Atrophy_rate * DTIME
        END IF
        ! Update the volume loss
        var_theta = 1.0D0 + var_theta_aging + var_theta_protein
        STATEV(1) = var_theta
        STATEV(2) = var_theta_aging
        STATEV(3) = var_theta_protein
        ! STATEV(5) = MatType
        STATEV(5) = TEMP
        ! ********************************************************************
        ! Compute the elastic part of the deformation gradient tensor
        F_tau = 0.0D0
        F_tau = DFGRD1


        OriMatrix = 0.0D0
        DO I = 1, 3
          DO J = 1, 3
            OriMatrix(I,J) = OriVector(I)*OriVector(J)
          END DO
        END DO
        F_a = 0.0D0
        IF (MatType .EQ. 0) THEN
          ! Gray matter
          F_a = Identity*var_theta**(1.0D0/3.0D0)
          F_e = F_tau / var_theta**(1.0D0/3.0D0)
        ELSE IF (MatType .EQ. 1) THEN
          ! White matter
          F_a = Identity*var_theta**(1.0D0/2.0D0) + (1.0D0 - var_theta**(1.0D0/2.0D0))*OriMatrix
          inv_F_a = 1.0D0/var_theta**(1.0D0/2.0D0)*Identity + (1.0D0-1.0D0/var_theta**(1.0D0/2.0D0))*OriMatrix
          F_e = matmul(F_tau, inv_F_a)

        END IF

        detF_e = F_e(1,1)*F_e(2,2)*F_e(3,3) + F_e(1,2)*F_e(2,3)*F_e(3,1) + F_e(1,3)*F_e(2,1)*F_e(3,2)
     1    - F_e(1,3)*F_e(2,2)*F_e(3,1) - F_e(1,2)*F_e(2,1)*F_e(3,3) - F_e(1,1)*F_e(2,3)*F_e(3,2)
        ! Compute the left Cauchy-Green tensor
        B = matmul(F_e, transpose(F_e))
        ! Compute the stress tensor (Hyperelasticity)
        Sigma_Cauchy = 0.0D0
        Sigma_Cauchy = 1.0D0/detF_e*(mu*B + (lambda*log(detF_e) - mu)*Identity)
        ! Compute the stiffness tensor (Hyperelasticity)
        C_mat = 0.0D0
        DO I = 1, 3
            DO J = 1, 3
                DO K= 1, 3
                    DO L = 1, 3
                    C_mat(I,J,K,L) = C_mat(I,J,K,L) + 1.0/detF_e*(mu-lambda*log(detF_e))*
     1        (Identity(I,K)*Identity(J,L) + Identity(I,L)*Identity(J,K)) + (lambda)*(Identity(I,J)*Identity(K,L))
     2        + 1.0/2.0*(Sigma_Cauchy(I,K)*Identity(J,L) + Identity(I,K)*Sigma_Cauchy(J,L) +
     3        Sigma_Cauchy(I,L)*Identity(J,K) + Identity(I,L)*Sigma_Cauchy(J,K))
                    END DO
                END DO
            END DO
        END DO


        ! Update the stress tensor
        STRESS(1) = Sigma_Cauchy(1,1)
        STRESS(2) = Sigma_Cauchy(2,2)
        STRESS(3) = Sigma_Cauchy(3,3)
        STRESS(4) = Sigma_Cauchy(1,2)
        STRESS(5) = Sigma_Cauchy(1,3)
        STRESS(6) = Sigma_Cauchy(2,3)
        ! Update the stiffness tensor
        DDSDDE = 0.0D0
        DDSDDE(1,1) = C_mat(1,1,1,1)
        DDSDDE(1,2) = C_mat(1,1,2,2)
        DDSDDE(1,3) = C_mat(1,1,3,3)
        DDSDDE(1,4) = C_mat(1,1,1,2)
        DDSDDE(1,5) = C_mat(1,1,1,3)
        DDSDDE(1,6) = C_mat(1,1,2,3)

        DDSDDE(2,1) = C_mat(2,2,1,1)
        DDSDDE(2,2) = C_mat(2,2,2,2)
        DDSDDE(2,3) = C_mat(2,2,3,3)
        DDSDDE(2,4) = C_mat(2,2,1,2)
        DDSDDE(2,5) = C_mat(2,2,1,3)
        DDSDDE(2,6) = C_mat(2,2,2,3)

        DDSDDE(3,1) = C_mat(3,3,1,1)
        DDSDDE(3,2) = C_mat(3,3,2,2)
        DDSDDE(3,3) = C_mat(3,3,3,3)
        DDSDDE(3,4) = C_mat(3,3,1,2)
        DDSDDE(3,5) = C_mat(3,3,1,3)
        DDSDDE(3,6) = C_mat(3,3,2,3)

        DDSDDE(4,1) = C_mat(1,2,1,1)
        DDSDDE(4,2) = C_mat(1,2,2,2)
        DDSDDE(4,3) = C_mat(1,2,3,3)
        DDSDDE(4,4) = C_mat(1,2,1,2)
        DDSDDE(4,5) = C_mat(1,2,1,3)
        DDSDDE(4,6) = C_mat(1,2,2,3)

        DDSDDE(5,1) = C_mat(1,3,1,1)
        DDSDDE(5,2) = C_mat(1,3,2,2)
        DDSDDE(5,3) = C_mat(1,3,3,3)
        DDSDDE(5,4) = C_mat(1,3,1,2)
        DDSDDE(5,5) = C_mat(1,3,1,3)
        DDSDDE(5,6) = C_mat(1,3,2,3)

        DDSDDE(6,1) = C_mat(2,3,1,1)
        DDSDDE(6,2) = C_mat(2,3,2,2)
        DDSDDE(6,3) = C_mat(2,3,3,3)
        DDSDDE(6,4) = C_mat(2,3,1,2)
        DDSDDE(6,5) = C_mat(2,3,1,3)
        DDSDDE(6,6) = C_mat(2,3,2,3)
      RETURN
      END
