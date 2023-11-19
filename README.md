# BaCoN-II
This is the new version of [BaCoN](https://github.com/Mik3M4n/BaCoN) with an improved noise model for the theoretical error. We're now using a variety of smooth curves that approximate the error in the theoretical modelling on smaller scales. 

**The training of a model can now take up to 4 days.** (for 20,000 training spectra with 10 noise realisations each)

## New noise model

We have produced 1000 curves with random fluctations that are saved in the folder ```/data/theory_error/filters_earliest_onset/```. (With names ```1.txt``` to ```1000.txt```) The theory error curves become relevant from about $k = 0.03 \ \mathrm{h/Mpc}$ and have different shapes. They are scaled to a peak amplitude that can be set with the ```sigma_curves```-parameter in the ```train-parameters.py``` file. We recommend $\sigma_\mathrm{curves} = 0.05$ for EE2 data with $k_\mathrm{max} = 2.5 \ \mathrm{h/Mpc}$. 
Some example curves with $\sigma_\mathrm{curves} = 0.10$ are shown below.

<img src="https://github.com/cosmicLinux/BaCoN-II/assets/142009018/7ecece0e-876d-4e15-baf7-2128f5e7db65"
     width="300" />

A plot of 10 different realisations of theory error curves (scaled to 5%) superimposed onto some LCDM example spectra (including cosmic variance) is shown below.
     
<img src="https://github.com/cosmicLinux/BaCoN-II/assets/142009018/1c945ac0-67dc-45e7-8a4a-d28e417e3719"
     width="350" />

The amplitude of the curves can be rescaled with a uniform distribution to obtain some smaller errors as well. This option can be selected with the training parameter ```rescale_curves = 'uniform'```.

<img src="https://github.com/cosmicLinux/BaCoN-II/assets/142009018/a89b264c-d848-4ac6-805d-e5ad050c6c8c"
     width="300" />

The Cosmic Variance is still modelled as Gaussian noise on large scales. Shot noise is also a Gaussian noise, though we recommend to leave it out.

## Data structure
Get the spectra from [Ben's Google drive folder](https://drive.google.com/drive/folders/1MCYvhlsIsBoSNJEBGuofieieQ_VfPPJk) and put them into the data folder. Copy the normalisation file ```planck_ee2.txt``` from the ```data/normalisation/``` folder into the train and test data folders. The resulting data structure should look like this:

```bash
data/train_data/
		├── dgp/
			├──1.txt
			├──2.txt
			├──...
		├── fR/
			├──1.txt
			├──2.txt
			├──...
		├── lcdm/
			├──1.txt
			├──2.txt
			├──...
		├── wcdm/
			├──1.txt
			├──2.txt
			├──...	
		└── planck_ee2.txt		
```

Adapt the name of the training data folder in the ```train-parameters.py``` file accordingly (using the ```DIR``` parameter). The name of the test data folder can be set when the testing is started (see below).

## Training

Change the ```train-parameters.py``` file to set the training parameters that are then passed on to ```train.py```. 
To train the model with a theory error of 5 % execute
```bash
python3 train-curves-parameter.py --sigma_curves='0.05'
```

All the parameters are described in the file but we will explain the most important ones here:

* ```DIR```: path to the training data,e.g. ```'data/train_data'```, use ```train_fname``` to set the name of the training data in the model name
* ```norm_data_name```: path to the file of the normalisation spectrum, e.g. ```'/planck_ee2.txt'```, use ```planck_fname``` to set the name of the normalisation in the model name
* ```k_max```: maximal wavenumber of spectrum used
* ```sample_pace```: only sample every nth k-bin, we recommend n = 4 for the supplied spectra
* ```save_processed_spectra```: Set to ```True``` if the first batch of normalised and noisy spectra should be written to a file to plot them later. Only recommended for a special training run with ```n_epochs``` = 1.
* ```batch_size```: how many spectra per batch. **Has to be adapted to the number of classes.** Must be a multiple of (number of classes) * (noise realisations), e.g. 4 classes, 10 noisy samples -> must be multiple of 40, for example 8000 for 20,000 spectra per class
* ```fname_extra```: appended to the automatically generated model name, to quickly find model in folder

The noise parameters are:

* ```add_noise```: if ```True```, then noise gets added according to the following parameters:
     * ```n_noisy_samples```: number of noise samples added to every training (and testing) spectrum, we suggest 10.
     * ```add_cosvar```: if ```True```, adds Gaussian noise on large scales, depends on survey volume, here adapted for the Euclid telescope.
     * ```add_shot```: if ```True```, adds Gaussian noise to produce the shot noise of a Euclid-like Galaxy survey. We recommend ```False``` for the matter power spectrum.
     * ```add_sys```: if ```True```, theory error curves are added to account for the theoretical error in the modelling
          * ```curves_folder``` path to the folder with files containing the theory error curves
          * ```sigma_curves``` maximal amplitude of the plateau of the theory error curves on small scales (as added to the normalised power spectrum). It can be set in the ```train-parameters.py``` file but it can also be passed on as a parameter in the command line. (See above)
          * ```rescale_curves``` rescale the amplitude of theory error curves. Distribution can be ```uniform```(recommended), ```gaussian``` or ```None```.

When changing the total number of classes (equivalent to the number of folders in the training data) then the batch size has to be adapted accordingly. The new class names have to be added to the c1 parameter that is set in the subprocess call at the end of the train-parameters.py file.

The name of the model is automatically generated from the training parameters in ```train-parameters.py``` as 
<pre> curves_<i>&lt;train_name&gt;</i>_samplePace<i>&lt;sample_pace&gt;</i>_kmax<i>&lt;k_max&gt;</i>_planck-<i>&lt;planck_fname&gt;</i>_epoch<i>&lt;n_epochs&gt;</i>_batchsize<i>&lt;batch_size&gt;</i>_noiseSamples<i>&lt;n_noisy_samples&gt;</i>_wCV_noShot_wSys_rescale<i>&lt;rescale_curves&gt;</i>_GPU_sigmaCurves<i>&lt;sigma_curves&gt;</i>_<i>&lt;fname_extra&gt;</i>
</pre>




## testing

To test a trained model with a test data set and produce a confusion matrix for the classification run

<pre>
python3 test.py --log_path='models/<i>&lt;model_name&gt;</i>/<i>&lt;model_name&gt;</i>_log.txt' --TEST_DIR='<i>&lt;path/to/test-data&gt;</i>' 
  --cm_name_custom='<i>&lt;cm_name&gt;</i>-noSys'
  --curves_folder='curve_files_sys/filters_earliest_onset' 
  --norm_data_name='/planck_ee2.txt' 
  --add_sys='False'
</pre>

Please adapt the following options

- ```--log_path``` Fill in the path for the log-file of the model to be tested. 
- ```--cm_name_custom``` Add an (optional) addition to the name of the cm-file. (confusion matrix)
- ```--curves_folder```Decide on whether to add a systematic error to the test spectra. Adapt the cm_name accordingly.
- ```--add_sys``` Choose ```True``` or ```False``` to include the systematic error or leave it out. This overwrites the choice in the training of the model. For ```True``` the path to the folder with curves files (see above) has to be added.
