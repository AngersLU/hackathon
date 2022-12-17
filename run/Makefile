test:=
Test:= +$(test)

NOVAS	:= /eda/tools/snps/verdi/R-2020.12/share/PLI/VCS/LINUX64
EXTRA	:= -P ${NOVAS}/novas.tab\
		${NOVAS}/pli.a

RTL_FLIST := -f ../filelist/hackathon.f \

TB_FLIST :=  -f ../filelist/tb.f \
	#+vcs+initreg+random  \

SIM_TOOL     := vcs
SIM_OPTIONS  := -full64 -debug_acc+all +v2k -sverilog -timescale=1ns/10ps \
                ${EXTRA} \
				-kdb \
 				+error+500\
                +notimingcheck \
				+nospecify \
				+delay_mode_distributed \
                +vcs+flush+all \
                +lint=TFIPC-L \
				+incdir+../vsrc \

WAVE_TOOL := verdi
WAVE_FILE := asic_top.fsdb

comp : 
	${SIM_TOOL} ${SIM_OPTIONS} ${TB_FLIST} ${RTL_FLIST} -top tb -l compile.log

sim:
	./simv -l run.log 

wave:
	${WAVE_TOOL}  -ssf ${WAVE_FILE} -nologo  


.PHONY : clean
clean :
	rm -rf csrc simv.daidir simv ucli.key vcdplus.vpd DVEfiles INCA_libs asic_top.fsdb* *.log verdi_config_file novas.* verdiLog
