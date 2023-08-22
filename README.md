# BaCoN-II
This ais the new version of [BaCoN](https://github.com/Mik3M4n/BaCoN) with an improved noise model for the theoretical error. We're now using smooth curves that approximate the error in the theoretical modelling on small scales. The curves are produced by an adapted version of the [smurves](https://github.com/moews/smurves) package. start all at k = 0.03 h/Mpc and have different shapes produced with an . 323 curves files

![image](https://github.com/cosmicLinux/BaCoN-II/assets/142009018/4e37020f-a066-4d64-a88d-7a96dac51698)


The Cosmic Variance is still modelled as a Gaussian noise on large sclaes. Shot noise is also a Gaussian noise, though we recommend to leave it out.

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


