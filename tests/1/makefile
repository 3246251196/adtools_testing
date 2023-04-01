PROG=main$(INFIX)_test_1.exe
LOG_FILE=log$(INFIX).txt
.PHONY: all
all: $(PROG)
$(PROG): main$(INFIX).o
	@echo "#####" >> $(LOG_FILE)
	@echo "Link phase for $@" >> $(LOG_FILE)
	@echo "#####" >> $(LOG_FILE)
	$(CXX) $(LDFLAGS) -o $@ $^ 2>&1 | tee -a $(LOG_FILE)
	@echo "#####" >> $(LOG_FILE)
	@echo "ppc-amigaos-readelf -d for $@" >> $(LOG_FILE)
	@echo "#####" >> $(LOG_FILE)
	ppc-amigaos-readelf -d $(PROG) | tee -a $(LOG_FILE)

.PHONY: clean
clean:
	@-rm *.o *.exe log*.txt

main$(INFIX).o: main.cpp
	@echo "#####" >> $(LOG_FILE)
	@echo "Compile phase for $@" >> $(LOG_FILE)
	@echo "#####" >> $(LOG_FILE)
	$(CXX) $(CXXFLAGS) -c -o $@ $^ 2>&1 | tee -a $(LOG_FILE)
