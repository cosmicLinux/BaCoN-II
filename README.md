# BaCoN-II
This is the new version of [BaCoN](https://github.com/Mik3M4n/BaCoN) with an improved noise model for the theoretical error. We're now using smooth curves that approximate the error in the theoretical modelling on small scales. 
The curves are produced by an adapted version of the [smurves](https://github.com/moews/smurves) package. They all start at $k = 0.03 \ \mathrm{h/Mpc}$ and have different shapes produced by smurves. They are scaled according to a Gaussian distribution centred on 0. Tha standard deviation of the amplitude can be set with the ```sigma_curves```-parameter in the ```train-curves-parameter.py``` file. We recommend $\sigma = 0.05$ for EE2 data.
Some example curves with $\sigma = 0.04$ are shown below.

![image](https://github.com/cosmicLinux/BaCoN-II/assets/142009018/4e37020f-a066-4d64-a88d-7a96dac51698)

In total there are 323 curves files with 10,000 curves per file. (The first line of every curve file contains the k-values) The size is chosen so that one curve file can be used for one batch with the size of 2500 and four z-bins. The curve files (with the names ```curve_file_batch#.txt```) should be placed in the folder ```data/curve_files_sys/curve_files_train1k_2500batchsize_sysFactor0o04_start0o03_dirChange0```, alternatively the ```curves_folder``` in the file ```train-curves-parameter.py``` should be adapted.

The Cosmic Variance is still modelled as Gaussian noise on large scales. Shot noise is also a Gaussian noise, though we recommend to leave it out.

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


