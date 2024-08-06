class DogAgeCalculator {
  static String calculateAge(String birthDateString) {
    if (birthDateString != '') {
      DateTime birthDate = DateTime.parse(birthDateString);
      DateTime currentDate = DateTime.now();

      int years = currentDate.year - birthDate.year;
      int months = currentDate.month - birthDate.month;

      if (months < 0) {
        years--;
        months += 12;
      }
      String yearStr = years == 1 ? "yr" : "yrs";
      String monthStr = months == 1 ? "mo" : "mos";

      String ageStr = "";
      if (years > 0) {
        ageStr = "$years $yearStr";
      }
      if (months > 0) {
        if (ageStr.isNotEmpty) {
          ageStr += " ";
        }
        ageStr += "$months $monthStr";
      }

      return ageStr.isEmpty ? "0 mos" : ageStr;
    } else {
      return '';
    }
  }
}
