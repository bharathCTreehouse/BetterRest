# BetterRest

This is an app built using SwiftUI that predicts what time the user needs to go to bed given: His wake up time in the morning, the desired amount of sleep (In hours) and the number of cups of coffee he consumes per day.

We use the **Create ML** MAC app to train our model using a sample CSV file containing around 10k records. The template used was 'Tabular Regression'. We need to specify the name of the column that needs prediction along with other column value(s) that needs to be considered as input.
The **Create ML** app partitions the given CSV file into 2 parts: One for model training and the other for applying the trained model for validation.
Once we are done training our model, we download the 'mlmodel' file and include it in our Xcode project. In our Xcode project, we use **CoreML** to consume data present in the 'mlmodel' file and make the prediction.

Used the following UI components:
1. DatePicker
2. Stepper


Learning source: Hacking With Swift.
