import arcpy
arcpy.ImportToolbox(r"@\Spatial Statistics Tools.tbx")
arcpy.stats.HotSpotAnalysisComparison(
    in_hot_spot_1="GACHotSpots",
    in_hot_spot_2="GPCHotSpots",
    out_features=r"C:\Users\hxl786\Dropbox\Working File\Working Papers\Gao23_Solar School\Solar School_0919\Default.gdb\PoorComparison",
    num_neighbors=8,
    num_perms=999,
    weighting_method="FUZZY",
    similarity_weights="-3 -3 1;3 3 1;-3 -2 0.71;3 2 0.71;-3 -1 0.55;3 1 0.55;-2 -2 1;2 2 1;-2 -1 0.78;2 1 0.78;-1 -1 1;1 1 1;0 0 1",
    in_weights_table=None,
    exclude_nonsig_features="NO_EXCLUDE"
)
