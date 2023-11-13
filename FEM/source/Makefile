debug: 
	rm -f *.o
	ifort -g load_params.f generate_climate_data_daily.f housing_model.f storage_model.f application_model.f grazing_model.f model_driver_daily.f generate_factors_daily.f main_daily.f
	gfortran load_params.o generate_climate_data_daily.o housing_model.o storage_model.o application_model.o grazing_model.o model_driver_daily.o generate_factors_daily.o main_daily.o -o FEM_daily.debug
all:
	rm -f *.o
	ifort -c -auto -zero -extend-source 132 load_params.f generate_climate_data_daily.f housing_model.f storage_model.f application_model.f grazing_model.f model_driver_daily.f generate_factors_daily.f main_daily.f 
	ifort load_params.o generate_climate_data_daily.o housing_model.o storage_model.o application_model.o grazing_model.o model_driver_daily.o generate_factors_daily.o main_daily.o -o FEM_daily.out


clean:
	rm -f *.o FEM_daily.out

