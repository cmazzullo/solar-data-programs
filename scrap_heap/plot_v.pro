pro plot_v, dws
  filename = "temp_idl_output.txt"
  dump_velocity_output, filename, dws
  spawn, "python read_idl_output.py"
end
