# BaCoN-II
This is the new version of [BaCoN](https://github.com/Mik3M4n/BaCoN) with an improved noise model for the theoretical error. We're now using smooth curves that approximate the error in the theoretical modelling on small scales. 
**The training of a model can now take up to 5 days.**

The curves are produced by an adapted version of the [smurves](https://github.com/moews/smurves) package. They all start at $k = 0.03 \ \mathrm{h/Mpc}$ and have different shapes produced by smurves. They are scaled according to a Gaussian distribution centred on 0. Tha standard deviation of the amplitude can be set with the ```sigma_curves```-parameter in the ```train-curves-parameter.py``` file. We recommend $\sigma = 0.05$ for EE2 data.
Some example curves with $\sigma = 0.04$ are shown below.

<img src="https://github.com/cosmicLinux/BaCoN-II/assets/142009018/4e37020f-a066-4d64-a88d-7a96dac51698" 
     width="300" />


In total there are 323 curves files with 10,000 curves per file. (The first line of every curve file contains the k-values) The size is chosen so that one curve file can be used for one batch with the size of 2500 and four z-bins. The curve files (with the names ```curve_file_batch#.txt```) should be placed in the folder ```data/curve_files_sys/curve_files_train1k_2500batchsize_sysFactor0o04_start0o03_dirChange0```, alternatively the ```curves_folder``` in the file ```train-curves-parameter.py``` should be adapted.

The Cosmic Variance is still modelled as Gaussian noise on large scales. Shot noise is also a Gaussian noise, though we recommend to leave it out.

## training

Change the ```train-curves-parameter.py``` file to set the training parameters that are then passed on to ```train.py```. 

The noise parameters are:

* ```add_noise```: if ```True```, then noise gets added according to the following parameters:
     * ```n_noisy_samples```: number of noise samples added to every training (and testing) spectrum.
     * ```add_cosvar```: if ```True```, adds Gaussian noise on large scales, depends on survey volume, here adapted for the Euclid telescope.
     * ```add_shot```: if ```True```, adds Gaussian noise to produce the shot noise of a Euclid-like Galaxy survey. Default is ```False```.
     * ```add_sys```: if ```True```, smooth curves are added to account for the theoretical error, their amplitude is drawn from a Gaussian distribution $\mathcal{N}(0,\sigma_\mathrm{curves})$.
          * ```curves_folder``` path to the folder with files containing systematic curves. Number of curves per file has to be at least number_z_bins * number_files_per_batch.
          * ```sigma_curves``` standard deviation of the normal distribution for curve amplitudes, default is $\sigma_\mathrm{curves}=4$ %.

Discontinued parameters of other modelling techniques for the systematic error are:

          *
          *

The name of the model is set by the training parameters in ```train-curves-parameter.py``` as 
<pre> curves_<i>&lt;train_name&gt;</i>_<i>&lt;test_name&gt;</i>_samplePace<i>&lt;sample_pace&gt;</i>_kmax<i>&lt;k_max&gt;</i>_<i>&lt;planck_fname&gt;</i>_epoch<i>&lt;n_epochs&gt;</i>_noiseSamples<i>&lt;n_noisy_samples&gt;</i>_wCV_noShot_wSys_sigmaCurves<i>&lt;sigma_curves&gt;</i>_<i>&lt;fname_extra&gt;</i>
</pre>

To train the model execute
```bash
python train-curves-parameter.py
```


## testing
- ```--log_path``` Fill in the path for the log-file of the model to be tested. 
- ```--cm_name_custom``` Add an (optional) addition to the name of the cm-file. (confusion matrix)
- ```--curves_folder```Decide on whether to add a systematic error to the test spectra. Adapt the cm_name accordingly.
- ```--add_sys``` If using a systematic error then the folder for curves files has to be added.

<pre>
python3 test.py --log_path='models/<i>&lt;model_name&gt;</i>/<i>&lt;model_name&gt;</i>_log.txt' --TEST_DIR='<i>&lt;path/to/test-data&gt;</i>' 
  --cm_name_custom='<i>&lt;cm_name&gt;</i>-noSys'
  --curves_folder='curve_files_sys/curve_files_train1k_2500batchsize_sysFactor0o04_start0o03_dirChange0' 
  --add_sys='False'
</pre>


