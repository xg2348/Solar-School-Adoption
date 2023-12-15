import arcpy
arcpy.ImportToolbox(r"@\Spatial Statistics Tools.tbx")
arcpy.stats.HotSpots(
    Input_Feature_Class="Gap_NW",
    Input_Field="GapCNW",
    Output_Feature_Class=r"C:\Users\hxl786\Dropbox\Working File\Working Papers\Gao23_Solar School\Solar School_0919\Default.gdb\GNWHotSpots",
    Conceptualization_of_Spatial_Relationships="K_NEAREST_NEIGHBORS",
    Distance_Method="EUCLIDEAN_DISTANCE",
    Standardization="ROW",
    Distance_Band_or_Threshold_Distance=None,
    Self_Potential_Field=None,
    Weights_Matrix_File=None,
    Apply_False_Discovery_Rate__FDR__Correction="APPLY_FDR",
    number_of_neighbors=8
)
