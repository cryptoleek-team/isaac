from contracts.design.constants import (
    G, MASS_SUN0, MASS_SUN1, MASS_SUN2, OMEGA_DT_PLANET, TWO_PI,
    RANGE_CHECK_BOUND, SCALE_FP, SCALE_FP_SQRT, DT 
)
from contracts.util.structs import (Vec2, Dynamic, Dynamics)
from contracts.libs.fpmath import (
    sqrt_fp, mul_fp, div_fp, mul_fp_ul, div_fp_ul, vec2_add2, vec2_add3
)

#####################################################################
# Functions to manipulate dynamics.
# Note that we can of course write generic methods for manipulating
# arrays of dynamic at the expense of overhead to achieve generality;
# here we choose performance.
#####################################################################

#
# Add two dynamics
#
func dynamics_add {} (dynamics0 : Dynamics, dynamics1 : Dynamics) -> (res : Dynamics):
    alloc_locals
    let (sun0 : Dynamic) = dynamic_add (dynamics0.sun0, dynamics1.sun0)
    let (sun1 : Dynamic) = dynamic_add (dynamics0.sun1, dynamics1.sun1)
    let (sun2 : Dynamic) = dynamic_add (dynamics0.sun2, dynamics1.sun2)
    let (merc : Dynamic) = dynamic_add (dynamics0.merc, dynamics1.merc)

    return ( Dynamics (sun0, sun1, sun2, merc) )
end

func dynamic_add {} (dynamic0 : Dynamic, dynamic1 : Dynamic) -> (res : Dynamic):
    return (Dynamic (
        q  = Vec2 (dynamic0.q.x + dynamic1.q.x, dynamic0.q.y + dynamic1.q.y),
        qd = Vec2 (dynamic0.qd.x + dynamic1.qd.x, dynamic0.qd.y + dynamic1.qd.y)
    ))
end

#
# Multiply a dynamics with a fixed-point scalar
#
func dynamics_mul_scalar_fp {range_check_ptr} (dynamics : Dynamics, scalar_fp : felt) -> (res : Dynamics):
    alloc_locals
    let (sun0 : Dynamic) = dynamic_mul_scalar_fp (dynamics.sun0, scalar_fp)
    let (sun1 : Dynamic) = dynamic_mul_scalar_fp (dynamics.sun1, scalar_fp)
    let (sun2 : Dynamic) = dynamic_mul_scalar_fp (dynamics.sun2, scalar_fp)
    let (merc : Dynamic) = dynamic_mul_scalar_fp (dynamics.merc, scalar_fp)

    return ( Dynamics (sun0, sun1, sun2, merc) )
end

func dynamic_mul_scalar_fp {range_check_ptr} (dynamic : Dynamic, scalar_fp : felt) -> (res : Dynamic):
    let (q_x)  = mul_fp (dynamic.q.x, scalar_fp)
    let (q_y)  = mul_fp (dynamic.q.y, scalar_fp)
    let (qd_x) = mul_fp (dynamic.qd.x, scalar_fp)
    let (qd_y) = mul_fp (dynamic.qd.y, scalar_fp)

    return (Dynamic (
        q  = Vec2(q_x, q_y),
        qd = Vec2(qd_x, qd_y)
    ))
end

#
# Multiply a dynamics with a scalar directly
#
func dynamics_mul_scalar {range_check_ptr} (dynamics : Dynamics, scalar : felt) -> (res : Dynamics):
    alloc_locals
    let (sun0 : Dynamic) = dynamic_mul_scalar (dynamics.sun0, scalar)
    let (sun1 : Dynamic) = dynamic_mul_scalar (dynamics.sun1, scalar)
    let (sun2 : Dynamic) = dynamic_mul_scalar (dynamics.sun2, scalar)
    let (merc : Dynamic) = dynamic_mul_scalar (dynamics.merc, scalar)

    return ( Dynamics (sun0, sun1, sun2, merc) )
end

func dynamic_mul_scalar {range_check_ptr} (dynamic : Dynamic, scalar : felt) -> (res : Dynamic):
    let q_x  = dynamic.q.x * scalar
    let q_y  = dynamic.q.y * scalar
    let qd_x = dynamic.qd.x * scalar
    let qd_y = dynamic.qd.y * scalar

    return (Dynamic (
        q  = Vec2(q_x, q_y),
        qd = Vec2(qd_x, qd_y)
    ))
end

#
# Divide a dynamics by a scalar directly
#
func dynamics_div_scalar {range_check_ptr} (dynamics : Dynamics, scalar : felt) -> (res : Dynamics):
    alloc_locals
    let (sun0 : Dynamic) = dynamic_div_scalar (dynamics.sun0, scalar)
    let (sun1 : Dynamic) = dynamic_div_scalar (dynamics.sun1, scalar)
    let (sun2 : Dynamic) = dynamic_div_scalar (dynamics.sun2, scalar)
    let (merc : Dynamic) = dynamic_div_scalar (dynamics.merc, scalar)

    return ( Dynamics (sun0, sun1, sun2, merc) )
end

func dynamic_div_scalar {range_check_ptr} (dynamic : Dynamic, scalar : felt) -> (res : Dynamic):
    let (q_x)  = div_fp_ul (dynamic.q.x, scalar)
    let (q_y)  = div_fp_ul (dynamic.q.y, scalar)
    let (qd_x) = div_fp_ul (dynamic.qd.x, scalar)
    let (qd_y) = div_fp_ul (dynamic.qd.y, scalar)

    return (Dynamic (
        q  = Vec2(q_x, q_y),
        qd = Vec2(qd_x, qd_y)
    ))
end