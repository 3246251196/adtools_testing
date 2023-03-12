PROG=main$(INFIX).exe
all: $(PROG)
$(PROG): main$(INFIX).o
	$(CXX) $(LDFLAGS) -o $@ $^ 2>&1 | tee -a log$(INFIX).txt

.PHONY: clean
clean:
	-rm *.o *.exe log*.txt

main$(INFIX).o: main.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $^ 2>&1 | tee log$(INFIX).txt
