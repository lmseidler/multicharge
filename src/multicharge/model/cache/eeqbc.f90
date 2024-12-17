! This file is part of multicharge.
! SPDX-Identifier: Apache-2.0
!
! Licensed under the Apache License, Version 2.0 (the "License");
! you may not use this file except in compliance with the License.
! You may obtain a copy of the License at
!
!     http://www.apache.org/licenses/LICENSE-2.0
!
! Unless required by applicable law or agreed to in writing, software
! distributed under the License is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the License for the specific language governing permissions and
! limitations under the License.

!> @file multicharge/model/cache/eeqbc.f90
!> Contains the cache class for the EEQ-BC charge model

!> Cache for the EEQ-BC charge model
module multicharge_eeqbc_cache
   use mctc_env, only: wp
   use mctc_io, only: structure_type
   use multicharge_model_cache, only: mchrg_cache
   use multicharge_ewald, only: get_alpha
   use multicharge_wignerseitz, only: new_wignerseitz_cell
   implicit none
   private

   !> Cache for the EEQ-BC charge model
   type, extends(mchrg_cache), public :: eeqbc_cache
      !> Local charge arrays
      real(wp), allocatable :: qloc(:)
      real(wp), allocatable :: dqlocdr(:, :, :)
      real(wp), allocatable :: dqlocdL(:, :, :)
      !> Full constraint matrix for 0d case
      real(wp), allocatable :: cmat(:, :)
      !> Contributions for every WSC image for diagonal elements of constraint matrix
      real(wp), allocatable :: cmat_diag(:, :)
      !> Derivative of constraint matrix w.r.t positions
      real(wp), allocatable :: dcdr(:, :, :)
      !> Derivative of constraint matrix w.r.t lattice vectors
      real(wp), allocatable :: dcdL(:, :, :)
      !> Store tmp array from xvec calculation for reuse
      real(wp), allocatable :: xtmp(:)
   contains
      !> Allocation of arrays, WSC creation
      procedure :: update
   end type eeqbc_cache

contains
   subroutine update(self, mol)
      class(eeqbc_cache), intent(inout) :: self
      type(structure_type), intent(in) :: mol

      !> Create WSC
      if (any(mol%periodic)) then
         call new_wignerseitz_cell(self%wsc, mol)
         call get_alpha(mol%lattice, self%alpha)
      end if

   end subroutine update

end module multicharge_eeqbc_cache
