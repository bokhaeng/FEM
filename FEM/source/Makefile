debug: 
	rm -f *.o
	pgf90 -g load_params.f generate_climate_data.f generate_activity_data.f housing_model.f storage_model.f application_model.f grazing_model.f norminv.f set_month_temps.f model_driver.f generate_factors.f regression_sensitivity.f
	pgf90 -g load_params.o generate_climate_data.o generate_activity_data.o housing_model.o storage_model.o application_model.o grazing_model.o norminv.o set_month_temps.o model_driver.o generate_factors.o regression_sensitivity.o -o FEM.out

all:
	pgf90 -fast load_params.f generate_climate_data.f generate_activity_data.f housing_model.f storage_model.f application_model.f grazing_model.f norminv.f set_month_temps.f model_driver.f generate_factors.f regression_sensitivity.f 
	pgf90 -fast load_params.o generate_climate_data.o generate_activity_data.o housing_model.o storage_model.o application_model.o grazing_model.o norminv.o set_month_temps.o model_driver.o generate_factors.o regression_sensitivity.o -o FEM.out

fem_daily:
	pgf90 -fast -traceback load_params.f generate_climate_data_daily.f generate_activity_data.f housing_model.f storage_model.f application_model.f grazing_model.f model_driver_daily.f generate_factors_daily.f main_daily.f 
	pgf90 -fast load_params.o generate_climate_data_daily.o generate_activity_data.o housing_model.o storage_model.o application_model.o grazing_model.o model_driver_daily.o generate_factors_daily.o main_daily.o -o FEM_daily.out


param_sens:
	pgf90 -fast load_params.f generate_climate_data.f generate_activity_data.f housing_model.f storage_model.f application_model.f grazing_model.f norminv.f set_month_temps.f model_driver.f generate_factors.f param_sensitivity.f 
	pgf90 -fast load_params.o generate_climate_data.o generate_activity_data.o housing_model.o storage_model.o application_model.o grazing_model.o norminv.o set_month_temps.o model_driver.o generate_factors.o param_sensitivity.o -o param_sens.out


uncertain:
	pgf90 -fast load_params.f generate_climate_data.f generate_activity_data.f housing_model.f storage_model.f application_model.f grazing_model.f norminv.f set_month_temps.f model_driver.f generate_factors.f uncertainty_analysis.f 
	pgf90 -fast load_params.o generate_climate_data.o generate_activity_data.o housing_model.o storage_model.o application_model.o grazing_model.o norminv.o set_month_temps.o model_driver.o generate_factors.o uncertainty_analysis.o -o uncertain.out

reg_sens:
	pgf90 -fast load_params.f generate_climate_data.f generate_activity_data.f housing_model.f storage_model.f application_model.f grazing_model.f norminv.f set_month_temps.f model_driver.f generate_factors.f regression_sensitivity.f 
	pgf90 -fast load_params.o generate_climate_data.o generate_activity_data.o housing_model.o storage_model.o application_model.o grazing_model.o norminv.o set_month_temps.o model_driver.o generate_factors.o regression_sensitivity.o -o FEM.out

tuned_sens:
	pgf90 -fast load_params.f generate_climate_data.f generate_activity_data.f housing_model.f storage_model.f application_model.f grazing_model.f norminv.f set_month_temps.f model_driver.f generate_factors.f tuned_sensitivity.f
	pgf90 -fast load_params.o generate_climate_data.o generate_activity_data.o housing_model.o storage_model.o application_model.o grazing_model.o norminv.o set_month_temps.o model_driver.o generate_factors.o tuned_sensitivity.o -o tuned_sens.out

test_farm:
	pgf90 load_params.f generate_climate_data.f generate_activity_data.f housing_model.f storage_model.f application_model.f grazing_model.f norminv.f set_month_temps.f model_driver.f generate_factors.f test_farm.f 
	pgf90 load_params.o generate_climate_data.o generate_activity_data.o housing_model.o storage_model.o application_model.o grazing_model.o norminv.o set_month_temps.o model_driver.o generate_factors.o test_farm.o -o test_farm.out

test_farm_daily:
	pgf90 load_params.f generate_climate_data.f generate_activity_data.f housing_model.f storage_model.f application_model.f grazing_model.f norminv.f set_month_temps.f model_driver_daily.f generate_factors.f test_farm_daily.f 
	pgf90 load_params.o generate_climate_data.o generate_activity_data.o housing_model.o storage_model.o application_model.o grazing_model.o norminv.o set_month_temps.o model_driver_daily.o generate_factors.o test_farm.o -o test_farm_daily.out


new_inv:
	pgf90 -g load_params.f generate_climate_data.f generate_activity_data.f housing_model.f storage_model.f application_model.f grazing_model.f norminv.f set_month_temps.f model_driver.f  
	pgf90 -fast load_params.o generate_climate_data.o generate_activity_data.o housing_model.o storage_model.o application_model.o grazing_model.o norminv.o set_month_temps.o model_driver.o  -o FEM.out

readmet:
	pgf90 -g testmet.f
	pgf90 -fast testmet.o

process_uncertainty:
	pgf90 -g process_uncertainty.f -o process_uncertainty.out

testread:
	pgf90 testread.f

clean:
	rm -f *.o FEM.out process_uncertainty.out tuned_sens.out uncertain.out test_farm.out param_sens.out

