debug:
	rm -f *.o
	pgf90 -g load_params.f generate_climate_data.f generate_activity_data.f housing_model.f storage_model.f application_model.f grazing_model.f norminv.f set_month_temps.f model_driver.f generate_factors.f regression_sensitivity.f
	pgf90 -g load_params.o generate_climate_data.o generate_activity_data.o housing_model.o storage_model.o application_model.o grazing_model.o norminv.o set_month_temps.o model_driver.o generate_factors.o regression_sensitivity.o -o FEM.out

all:
	pgf90 -fast load_params.f generate_climate_data.f generate_activity_data.f housing_model.f storage_model.f application_model.f grazing_model.f norminv.f set_month_temps.f model_driver.f generate_factors.f regression_sensitivity.f
	pgf90 -fast load_params.o generate_climate_data.o generate_activity_data.o housing_model.o storage_model.o application_model.o grazing_model.o norminv.o set_month_temps.o model_driver.o generate_factors.o regression_sensitivity.o -o FEM.out

clean:
	rm -f *.o FEM.out process_uncertainty.out tuned_sens.out uncertain.out test_farm.out param_sens.out
