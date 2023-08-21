# BaCoN-II

## training

Change the ```train-curves-parameter.py``` file to set the training parameters that are then passed on to ```train.py```. To execute the training run 

```
python train-curves-parameter.py
```


## testing
- ```--log_path``` Fill in the path for the log-file of the model to be tested. 
- ```--cm_name_custom``` Add an (optional) addition to the name of the cm-file. (confusion matrix)
- ```--curves_folder```Decide on whether to add a systematic error to the test spectra. Adapt the cm_name accordingly.
- ```--add_sys``` If using a systematic error then the folder for curves files has to be added.

<pre>
python3 test.py --log_path='models/<i>model_name</i>/<i>model_name</i>_log.txt' --TEST_DIR='<i>path/to/test-data</i>' 
  --cm_name_custom='<i>cm_name</i>-noSys'
  --curves_folder='curve_files_sys/curve_files_train1k_2500batchsize_sysFactor0o04_start0o03_dirChange0' 
  --add_sys='False'
</pre>


