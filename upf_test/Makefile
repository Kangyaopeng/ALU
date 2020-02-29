test:
	vcs -debug_all -full64 -sverilog inst.v top.v tb.sv -upf test.upf -pa_random_corrupt
	./simv	

clean:
	-rm -rf mvsim_native_reports simv* *log verilog.dump *.sdb 
	-rm -rf csrc mvdir succeed_test ucli.key *vpd vc_hdrs.h
