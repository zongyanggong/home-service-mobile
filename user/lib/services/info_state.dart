import 'package:flutter/material.dart';

class Info extends ChangeNotifier {
  double sleepValue = 3;
  setSleepValue(double value) {
    sleepValue = value;
    notifyListeners();
  }

  double moodValue = 3;
  setMoodValue(double value) {
    moodValue = value;
    notifyListeners();
  }

  double waterIntakeValue = 3;
  setWaterIntakeValue(double value) {
    waterIntakeValue = value;
    notifyListeners();
  }

  String? selectedExercise = "None";
  setSlectedExercise(String? value) {
    selectedExercise = value;
    notifyListeners();
  }

  bool isChecked = false;
  setIsSelected(bool value) {
    isChecked = value;
    notifyListeners();
  }

  String happinessText(double sliderValue) {
    return switch (sliderValue) {
      1 => "Horrible",
      2 => "Bad",
      3 => "Average",
      4 => "Good",
      5 => "Excellent",
      _ => "I don't know",
    };
  }

  String exerciseText(String? value) {
    return switch (value) {
      "None" => "no",
      "Little" => "little",
      "Some" => "some",
      "A lot" => "a lot",
      _ => "I don't know",
    };
  }

  String selectedText(bool value) {
    return switch (value) {
      true => "do",
      false => "didn't do",
    };
  }

  TextEditingController textInput = TextEditingController();
  setTextInput(String value) {
    textInput.text = value;
    notifyListeners();
  }

  resetInfo() {
    sleepValue = 3;
    moodValue = 3;
    waterIntakeValue = 3;
    selectedExercise = "None";
    isChecked = false;
    textInput.text = "";
  }
}
