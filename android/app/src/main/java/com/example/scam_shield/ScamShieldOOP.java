package com.example.scam_shield;


// 1. Abstraction: An abstract class defining a general security structure
abstract class SecurityProtocol {
    private String protocolName; // 2. Encapsulation: Private field

    public SecurityProtocol(String name) {
        this.protocolName = name;
    }

    // Getter for encapsulation
    public String getProtocolName() {
        return protocolName;
    }

    // Abstract method to be implemented by subclasses
    public abstract void executeScan();
}

// 3. Inheritance: AISecurity extends SecurityProtocol
class AISecurity extends SecurityProtocol {
    private double accuracyScore;

    public AISecurity(String name, double score) {
        super(name);
        this.accuracyScore = score;
    }

    // 4. Polymorphism: Overriding the abstract method
    @Override
    public void executeScan() {
        System.out.println("Executing " + getProtocolName() + " with AI accuracy: " + accuracyScore + "%");
        System.out.println("Status: Deep scanning for neural-network based scams...");
    }
    
    // Additional method for specific AI behavior
    public void updateAIModel() {
        System.out.println("Updating " + getProtocolName() + " learning database...");
    }
}

// Derived class for another type of security
class FirewallSecurity extends SecurityProtocol {
    public FirewallSecurity(String name) {
        super(name);
    }

    @Override
    public void executeScan() {
        System.out.println("Executing " + getProtocolName() + " (Network Level)...");
        System.out.println("Status: Blocking unauthorized incoming traffic.");
    }
}

// Main class to demonstrate the concepts
public class ScamShieldOOP {
    public static void runDemo() {
        System.out.println("--- ScamShield AI: Java OOP Demonstration ---");

        // Polymorphism: Using a base class reference for derived class objects
        SecurityProtocol aiShield = new AISecurity("Gemini Engine", 98.5);
        SecurityProtocol netShield = new FirewallSecurity("Cyber Guard");

        // Calling the overridden methods
        aiShield.executeScan();
        netShield.executeScan();

        // Specific behavior
        if (aiShield instanceof AISecurity) {
            ((AISecurity) aiShield).updateAIModel();
        }
    }
}
