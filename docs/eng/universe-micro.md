# Micro simulation

### The micro coordinate system
The planet is shaped like a cube of equal dimension on each side. Denoting the dimension of the cube as `D`, the surface of the cube is endowed with a **grid coordinate system** over integers by **unfolding** the cube to a 2D plane:
<img src="/assets/images/grid.png"/>

where:
- Face 3 is the top face, whose surface normal points upward from the orbital plane; Face 1 surface normal points downward from the orbital plane.
- Face 0 surface normal points toward +x in the **macro coordinate system** when planet rotation is 0.

Apparently, not every integer pair is a **valid grid coordinate** on the surface of the cube. For example, coordinates that lie within the square of `x = 0 ~ D-1` and `y = 0 ~ D-1` are not valid coordinates.

### Natural resources

##### Element types
All element types are defined in the namespace `core/contracts/design/constants.cairo` :: `ns_element_types`.

| Type index | Name |
| ------------------ | ---------------------- |
| 0                  | Raw iron               |
| 1                  | Refined iron           |
| 2                  | Raw aluminum           |
| 3                  | Refined aluminum       |
| 4                  | Raw copper             |
| 5                  | Refined copper         |
| 6                  | Raw silicon            |
| 7                  | Refined silicon        |
| 8                  | Raw plutonium-241      |
| 9                  | Enriched plutonium-241 |

##### Distribution
Every grid on the planet surface has a predefined concentration level of each raw element type, which is described by the distribution function. The distribution function utilizes the commonplace **perlin noise algorithm** to ensure somewhat smooth gradient along the distribution inexpensively.

The distribution functions are regulated in `core/contracts/util/distribution.cairo` and `core/contracts/util/perlin.cairo`.

### Devices

##### Device types
All device types are defined in the namespace `core/contracts/design/constants.cairo` :: `ns_device_types`.

| Type index  | Name  | Footprint | Description                                                              |
| ----------- | -------------------|----------------------------- | ------------------------------------------------------------------------ |
| 0           | Solar power generator   (SPG   | 1x1 | A power generation device that generates power from exposure to solar radiation    |
| 1           | Nuclear power generator (NPG)  | 3x3 | A power generation device that generates power from nuclear fission        |
| 2           | Iron harvester     (FE_HARV)   | 1x1 | A harvester device that harvests iron from the planet surface underneath |
| 3           | Aluminum harvester (AL_HARV)   | 1x1   | A harvester device that harvests aluminum from the planet surface underneath |
| 4           | Copper harvester   (CU_HARV)   | 1x1   | A harvester device that harvests copper from the planet surface underneath |
| 5           | Silicon harvester  (SI_HARV)   | 1x1   | A harvester device that harvests silicon from the planet surface underneath |
| 6           | Plutonium-241 harvester  (PU_HARV)  | 1x1   | A harvester device that harvests plutonium-241 from the planet surface underneath |
| 7           | Iron refinery       (FE_REFN)  | 2x2   | A transformer device that refines iron that is transported in via UTB    |
| 8           | Aluminum refinery   (AL_REFN)  | 2x2   | A transformer device that refines aluminum that is transported in via UTB|
| 9           | Copper refinery     (CU_REFN)  | 2x2   | A transformer device that refines copper that is transported in via UTB  |
| 10          | Silicon refinery    (SI_REFN)  | 2x2   | A transformer device that refines silicon that is transported in via UTB |
| 11          | Plutonium Enrichment Facility (PEF) | 2x2    | A transformer device that enriches plutonium-241 that is transported in via UTB |
| 12          | Universal Transporation Belt  (UTB) | 1x1    | A logistical device able to transport any element via contiguous placement |
| 13          | Universal Transmission Line   (UTL) | 1x1    | A logistical device able to transport energy via contiguous placement      |
| 14          | Universal Production & Storage Factility (UPSF) | 5x5 | Production & storage device for constructing any device including itself |
| 15          | Nuclear Driller & Propulsion Engine      (NDPE) | 5x5 | A device that is planted on the surface of the planet, drills the planet matter underneath, and propels the matter upward with energy generated from nuclear fission to exert reverse impulse to the planet |

##### Construction
There are resource and energy requirement for constructing devices, tabulated as follows:

| Name (shorthand) | Energy | Raw FE | Refined FE | Raw AL | Refined AL | Raw CU | Refined CU | Raw SI | Refined SI | Raw PU | Enriched PU |
| ---------------- | ------ | ------ | ---------- | ------ | ---------- | ------ | ---------- | ------ | ---------- | ------ | ----------- |
| SPG              | 2      | 0      | 0          | 0      | 50         | 0      | 0          | 0      | 100        | 0      | 0           |
| NPG              | 10     | 0      | 1000       | 0      | 1000       | 0      | 1000       | 0      | 500        | 0      | 250         |
| FE_HARV          | 2      | 300    | 0          | 0      | 0          | 0      | 0          | 50     | 0          | 0      | 0           |
| AL_HARV          | 4      | 300    | 0          | 1000   | 0          | 0      | 0          | 50     | 0          | 0      | 0           |
| CU_HARV          | 6      | 300    | 300        | 0      | 0          | 0      | 0          | 50     | 0          | 0      | 0           |
| SI_HARV          | 8      | 0      | 1000       | 0      | 200        | 0      | 0          | 50     | 0          | 0      | 0           |
| PU_HARV          | 10     | 0      | 1000       | 0      | 200        | 0      | 200        | 50     | 0          | 0      | 0           |
| FE_REFN          | 2      | 2000   | 0          | 1000   | 0          | 0      | 0          | 100    | 0          | 0      | 0           |
| AL_REFN          | 4      | 0      | 1000       | 1000   | 0          | 0      | 0          | 100    | 0          | 0      | 0           |
| CU_REFN          | 6      | 0      | 1000       | 0      | 1000       | 0      | 0          | 100    | 0          | 0      | 0           |
| SI_REFN          | 8      | 0      | 1000       | 0      | 1000       | 0      | 1000       | 100    | 0          | 0      | 0           |
| PEF              | 10     | 0      | 500        | 0      | 500        | 0      | 500        | 0      | 500        | 0      | 0           |
| UTB              | 1      | 0      | 0          | 0      | 25         | 0      | 5          | 5      | 0          | 0      | 0           |
| UTL              | 1      | 0      | 0          | 0      | 5          | 0      | 25         | 5      | 0          | 0      | 0           |
| UPSF             | 50     | 0      | 2000       | 0      | 2000       | 0      | 2000       | 0      | 2000       | 0      | 0           |
| NDPE             | 50     | 0      | 1000       | 0      | 1000       | 0      | 1000       | 0      | 1000       | 0      | 1000        |

For definitions in code:
- Resource requirement is defined in the namespace `core/contracts/design/manufacturing.cairo` :: `ns_manufacturing`.
- For energy requirement is defined in the namespace `core/contracts/design/constants.cairo` :: `ns_energy_requirements`.

##### Placement
Each device type takes up a **square-shaped footprint** of particular dimension. For example, harvester devices each take up 1x1 area, whereas transformer devices each take up 2x2 area, and each UPSF takes up a 5x5 area. Device overlap is prohibited. Footprint regulation can be found in the function `core/contracts/design/constants.cairo` :: `get_device_dimension_ptr()`

Special placement regulation is enforced with UTB and UTL:
1. A set of UTB/UTL needs to be contiguously placed as a whole. See the following illustration for examples.
2. The beginning coordinate of a set of UTB/UTL needs to neighbor its source device, while its ending coordinate needs to neighbor its destination device.

<img src="/assets/images/contiguity.png"/>
In the above illustration, green squares are source devices with labels starting with S, yellow squares are destination devices with labels starting with D, and blue lines are valid placement of UTB/UTL set. S1 is connected to D1. S3 is connected to D3. Both S2a and S2b are conneted to D2.
<br></br>

##### NDPE launches
To maximize the coordination requirement to survive this reality, Isaac automatically enforces **synchronized NDPE launch**: if **any** deployed NDPE is launched by its owner, **every** deployed NDPE, regardless of its owner, automatically launches at the same tick.


### Resource logistics

##### Resource harvesting
A deployed harvester device would automatically harvest its corresponding resource type from the planet grid underneath.

Note that:
1. The quantity harvested per tick is the **product** of **the resource concentration at the grid** and **an energy boost factor**. The energy boost factor is proportional to the energy supplied to the device via UTL. This mechanic is regulated in the namespace `core/contracts/util/logistics.cairo` :: `ns_logistics_harvester`.
2. Each harvester device has a maximum quantity of raw resource it can carry without having it transported off via UTB. The max carry quantities are regulated in the namespace `core/contracts/design/constants.cairo` :: `ns_harvester_max_carry`.

##### Resource transformation
A deployed transformer device -- refineries for {FE, AL, CU, SI} or enrichment facility for Pu-241 -- transforms the incoming raw resource (transported in via UTB) into refined/enriched resource.

Note that:
1. Each transformer device has a maximum quantity of **raw** resource it can carry without having it transformed. The max carry quantities are regulated in the namespace `core/contracts/design/constants.cairo` :: `ns_transformer_max_carry`. This creates a kind of **backpressure**: if the rate of transformation does not exceed rate of incoming raw materials, the raw material will pile up and eventually its amount is stuck at max carry, encouraging player to energy-boost the rate of transformation to resolve the backpressure and improve throughput (see the next note).
2. The rate of transformation is the **product** of **a base quantity** and **an energy boost factor**. The energy boost factor is proportional to the energy supplied to the device via UTL. This mechanic is regulated in the namespace `core/contracts/util/logistics.cairo` :: `ns_logistics_transformer`.

##### Resource transportation
A deployed and contiguous set of UTBs transports resource from its source device to its destination device. Note that the rate of transportation is the product of `the quantity of resource at source device` and `a decay factor`. Having the quantity of resource at source device in the product creates a **forward pressure** effect. The decay factor is an **exponential decay over the length** of UTB set, which reflects transportation efficiency drop over increased distance.

Note that multiple fan-in (multiple source devices feeding resource to one destination device) and fan-out (one source device feeding resource to multiple destination devices) are doable and sometimes desirable. Fan-in/out are concepts [borrowed](https://en.wikipedia.org/wiki/Fan-in) from the logical circuit design domain.

The transportation mechanics are regulated in `core/contracts/util/logistics.cairo` :: `ns_logistics_utb`.

### Power logistics

##### Power generation
Power generation devices include solar power generator (SPG) and nuclear power generator (NPG):
- SPG's rate of power generation depends on solar exposure, which is computed from which face the SPG is deployed on, planet rotation, and the distance from the planet to the suns. For example, the planet face pointing away from a given sun is in the shadow of the planet and subsequently does not receive solar radiation from that sun. Further, for simplicity, suns are considered completely transparent, meaning a sun's radiation would penetrate another sun with 100% transmittance. These mechanics are regulated in the namespaces `core/contracts/micro/micro_solar.cairo` :: `ns_micro_solar` and `core/contracts/util/logistics.cairo` :: `ns_logistics_xpg`.
- NPG's rate of power generation depends on a base rate and a energy boost factor. The mechanics are regulated in the namespace `core/contracts/util/logistics.cairo` :: `ns_logistics_xpg`.

##### Power transmission
A deployed and contiguous set of UTLs transports energy from its power-generating source device to its power-consuming destination device. Note that the rate of transmission is the product of `the quantity of energy at source device` and `a decay factor`. Having the quantity of energy at source device in the product creates a **forward pressure** effect. The decay factor is an **exponential decay over the length** of UTL set, which reflects transmission efficiency drop over increased distance.

The transmission mechanics is regulated in `core/contracts/util/logistics.cairo` :: `ns_logistics_utl`.

### Micro world forwarding
The procedure of forwarding the micro world is akin to the [simulation](https://en.wikipedia.org/wiki/Logic_simulation) of pipelined logical circuits. In particular, each device is analogous to a flip-flop register, and each contiguous set of UTB/UTL is analogous to combinational logic between a pair of flip-flop registers. Resource harvested / transformed at a given device is analogous to propagating from a register's D pin to Q pin, whereas resource/energy moving along UTB/UTL is analogous to propagating logical signals across a combinational logic from its source register to its destination register.

At every tick, the micro world is forwarded by the following steps:
1. Each deployed device updates its resource or energy. Each power-generating device updates the quantity of energy it holds based on power generation mechanics. Each harvester device updates the quantity of resource it holds based on harvesting mechanics.s Each tranformer device updates the quantities of before-transform and after-transform resources it holds based on transformation mechanics.
2. For each deployed UTB set, resource is transported from its source device to its destination device based on the resource transportation mechanics.
3. For each deployed UTL set, energy is transmitted from its source device to its destination device.

The procedure for forwarding the micro world is regulated in the namespace `contracts/core/micro/micro_forwarding.cairo` :: `ns_micro_forwarding`.
