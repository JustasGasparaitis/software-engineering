// Justas Gasparaitis, 1 kursas, 5 grupe
// 1 uzduotis
//
// Vieta: C:\Users\Gamer\Desktop\1uzduotis
// Kompiliavimas: javac Main.java
// Paleidimas:	  java Main

// Duomenu ivedimui is konsoles
import java.io.Console;   

public class Main {

// Pagrindine funkcija
public static void main(String args[]) {
	
	// Sukuriama konsole
	Console c = System.console();
	
	// Klausiama vardo
	System.out.println("Koks Jusu vardas?");
	String name = c.readLine();
	String nameConverted = convertName(name);
	
	// Pasisveikinama
	System.out.println("Sveiki, " + nameConverted);
	
	// Klausiama gimimo menesio
	int month = getMonth();
	
	// Pranesamas gimimo metu laikas
	String season = getSeason(month);
	System.out.println("Jus gimete " + season);
}

// Keiciamas vardo linksnis
static String convertName(String name) {
	String nameEnd = name.substring(name.length() - 2);
	String nameConverted = name;
	switch(nameEnd) {
			case "as":
			nameConverted = nameConverted.substring(0, nameConverted.length() - 1) + "i";
			break;
			case "is":
			case "ys":
			nameConverted = nameConverted.substring(0, nameConverted.length() - 1);
			break;
			case "us":
			nameConverted = nameConverted.substring(0, nameConverted.length() - 2) + "au";
			break;
		}
	return nameConverted;
}

// Gaunamas menesis is konsoles
static int getMonth() {
	Console c = System.console();
	System.out.println("Koks Jusu gimimo menesis?");
	int monthInteger = 0;
	String monthString = "";
	while (monthInteger == 0) {
		monthString = c.readLine();
		monthString = monthString.toLowerCase();
		
		switch(monthString) {
			case "sausis":
			monthInteger = 1;
			break;
			case "vasaris":
			monthInteger = 2;
			break;
			case "kovas":
			monthInteger = 3;
			break;
			case "balandis":
			monthInteger = 4;
			break;
			case "geguze":
			monthInteger = 5;
			break;
			case "birzelis":
			monthInteger = 6;
			break;
			case "liepa":
			monthInteger = 7;
			break;
			case "rugpjutis":
			monthInteger = 8;
			break;
			case "rugsejis":
			monthInteger = 9;
			break;
			case "spalis":
			monthInteger = 10;
			break;
			case "lapkritis":
			monthInteger = 11;
			break;
			case "gruodis":
			monthInteger = 12;
			break;
			default:
			System.out.println("Koks Jusu gimimo menesis?");
			monthInteger = 0;
		}
	}
	return monthInteger;
}

// Metu laiko nustatymas
static String getSeason(int month) {
	String season = "";
	switch(month) {
		case 12:
		case 1:
		case 2:
		season = "ziema";
		break;
		case 3:
		case 4:
		case 5:
		season = "pavasari";
		break;
		case 6:
		case 7:
		case 8:
		season = "vasara";
		break;
		case 9:
		case 10:
		case 11:
		season = "rudeni";
		break;
	}
	return season;
}
}