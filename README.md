# GARNO
GNSS-A Ranging Network Optimizer

The design of acoustic trajectories in Global Navigation Satellite Systems (GNSS) is crucial for precise underwater geodetic positioning. However, trajectory designs based on common positioning models suffer significant setbacks due to the drastic variations in sound velocity. Therefore, we propose a GNSS-A trajectory optimization criterion based on the positioning model augmented with Zenithal Atmospheric Delay (ZAD) parameters incorporating sound velocity variations. Specifically, a class of rose trajectories is discussed under criteria based on both common and ZAD models.
The results indicate that smaller trajectories yield lower accuracy in estimating ZAD parameters, further impacting the coordinate precision related to the correlation between ZAD parameters and coordinates. However, when using the common positioning model to disregard the influence of sound velocity variations, it is necessary to reduce the size of the sea surface trajectory. This suggests that, in practice, the size of sea surface trajectories should be slightly smaller than the ideal scenario where it is challenging to completely eliminate system errors. However, regarding the effect of sound velocity variations, the current traditional size of GNSS-A trajectories deviates significantly from the optimal trajectory.
In the context of marine geodesy, this highlights the importance of considering sound velocity variations and optimizing trajectory designs to improve the accuracy of underwater geodetic positioning.

The program mainly includes

1. Depth radius ratio setting
   
2. Sea surface control network carrier trajectory setting
   
3. Subsea control network setup
   
4. Observation time setting
   
5. Background sound speed field settings
    
6. Sound speed gradient setting
    
7. Accidental and systematic error settings

[1] Xue, S., Wang, K., Li, B., Zhu, J., & Xiao, Z. (2024). GNSS-A Trajectory Optimization and Its Rose-Curve Solution Regarding Acoustic Delay Parameter Identification. Marine Geodesy, 1–42. https://doi.org/10.1080/01490419.2024.2435269

[2] Wang K , Xue S , Xiao Z ,et al.2025.GNSS-A observation model with attached oceanic slowness gradient[J].Earth Science Informatics, 18(1).

[3] 周杰,薛树强,肖圳,等.海洋声速场水平梯度对海底大地测量定位的影响[J].测绘学报,2024,53(12):2328-2337.DOI:10.11947/j.AGCS.2024.20230551.

## version
GARNO v0.0.1 (2024.1.20)

## Fundings
This study was financially supported by the National Natural Science Foundation of China (41931076, 42474014), Laoshan Laboratory (LSKJ202205100, LSKJ202205105), and the Independent Research Project of State Key Laboratory of Geo-information Engineering (SKLGIE2023-ZZ-8).

## Instructions for use
Test version：Matlab R2022a

### File path settings
Set the entire toolbox path to include the path, and program call data is usually a relative path

### Program Running
Directly run the Main.m file

#### Depth radius ratio setting
The q in Line 1 of the Main.m file represents the depth radius ratio, which can be freely set, while the i0 in Line 3 represents the number of cycles

#### Sea surface control network carrier trajectory setting
SimulateRose. m file Line 8 sets the sea surface control network carrier trajectory, select 'Roses' here; The petal of Line 9 is set to the number of petals, with odd numbers representing the number of petals and even numbers representing half of the number of petals. The experiment in this article takes four petals as an example, so petal=2

1.Cirlce:Circular trajectory

2.Roses:Rose curve trajectory

3.Spirl:Spiral curve trajectory

4.Segment:Line segment trajectory

#### Submarine control network setup
SimulateRose. m file Line 45, select Customize here and set it as the center point position of the seabed

1.Customize:Custom settings

2.Polygon:Regular polygon parameter settings (center coordinates X, Y, number of sides, circumcircle radius, rotation angle)

#### Observation time setting
The TimeNum in line 17 of the SimulationRose. m file represents the total observation time, while the TNum in line 18 represents the interval between sea surface control points. The total experimental time in the text is 2 hours, and the interval between sea surface control points is 80 seconds

#### Background sound speed field settings
SimulationRose. m file INIData for Line 66 Set the initial sound velocity profile for SVPFilePath, and select SSP based for the experiment in the text; Line 72 sets a layering strategy (1. Unequally spaced layering; 2. Equally spaced layering) 

1.SSP-based：Construction based on sound velocity profile

2.EOF-based：EOF construction

#### Sound speed gradient setting
The C=v+n * y (j) of Line 122 in GenerateSVPGrid represents setting a horizontal gradient of n size in the N direction, and changing the size of n to change the horizontal gradient size


#### Accidental and systematic error settings
SimulateRose. m file Line 116 for error setting:

1.GNSS antenna error INIData CoordianteError=[0; 0; 0];

2.Propagation time error INIData TimeError=[0,0];

3.Timing error INIData TimeSerivceError=[0,0];

4.Attitude angle error INIData AttributeError=[0; 0; 0];

5.Arm length parameter error INIData ATDError=[0; 0; 0];

6.Submarine coordinate point error INIData SolidTideError=[0; 0; 0];








