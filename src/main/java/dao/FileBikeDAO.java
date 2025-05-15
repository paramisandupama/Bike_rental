package dao;

import config.DatabaseConfig;
import model.Bike;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * File-based implementation of BikeDAO.
 */
public class FileBikeDAO implements BikeDAO {
    
    @Override
    public List<Bike> getAllBikes() {
        List<Bike> bikes = new ArrayList<>();
        
        // Ensure the file exists
        DatabaseConfig.ensureFileExists(DatabaseConfig.BIKES_FILE);
        
        try (BufferedReader reader = new BufferedReader(new FileReader(DatabaseConfig.BIKES_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length == 8) {
                    Bike bike = new Bike(
                        Integer.parseInt(parts[0]),
                        parts[1],
                        parts[2],
                        parts[3],
                        Double.parseDouble(parts[4]),
                        Double.parseDouble(parts[5]),
                        parts[6],
                        parts[7]
                    );
                    bikes.add(bike);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        return bikes;
    }

    @Override
    public Bike getBikeById(int id) {
        try (BufferedReader reader = new BufferedReader(new FileReader(DatabaseConfig.BIKES_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length == 8 && Integer.parseInt(parts[0]) == id) {
                    return new Bike(
                        Integer.parseInt(parts[0]),
                        parts[1],
                        parts[2],
                        parts[3],
                        Double.parseDouble(parts[4]),
                        Double.parseDouble(parts[5]),
                        parts[6],
                        parts[7]
                    );
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    @Override
    public List<Bike> getAvailableBikes() {
        return getAllBikes().stream()
                .filter(Bike::isAvailable)
                .collect(Collectors.toList());
    }

    @Override
    public List<Bike> getBikesByType(String type) {
        return getAllBikes().stream()
                .filter(bike -> bike.getType().equalsIgnoreCase(type))
                .collect(Collectors.toList());
    }

    @Override
    public boolean addBike(Bike bike) {
        List<Bike> bikes = getAllBikes();
        
        // Generate a new ID (get the highest ID and add 1)
        int newId = 1; // Default if no bikes exist
        
        if (!bikes.isEmpty()) {
            newId = bikes.stream()
                    .mapToInt(Bike::getId)
                    .max()
                    .orElse(0) + 1;
        }
        
        bike.setId(newId);
        bikes.add(bike);
        
        return saveAllBikes(bikes);
    }

    @Override
    public boolean updateBike(Bike bike) {
        List<Bike> bikes = getAllBikes();
        boolean updated = false;
        
        // Replace the bike with the updated one
        for (int i = 0; i < bikes.size(); i++) {
            if (bikes.get(i).getId() == bike.getId()) {
                bikes.set(i, bike);
                updated = true;
                break;
            }
        }
        
        if (updated) {
            return saveAllBikes(bikes);
        }
        
        return false;
    }

    @Override
    public boolean deleteBike(int id) {
        List<Bike> bikes = getAllBikes();
        boolean removed = bikes.removeIf(bike -> bike.getId() == id);
        
        if (removed) {
            return saveAllBikes(bikes);
        }
        
        return false;
    }
    
    /**
     * Save all bikes to the file.
     * 
     * @param bikes The list of bikes to save
     * @return true if the bikes were saved successfully, false otherwise
     */
    private boolean saveAllBikes(List<Bike> bikes) {
        try {
            // Ensure directory exists
            DatabaseConfig.ensureFileExists(DatabaseConfig.BIKES_FILE);
            
            // Write all bikes to the file
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(DatabaseConfig.BIKES_FILE))) {
                for (Bike bike : bikes) {
                    writer.write(formatBikeForFile(bike));
                    writer.newLine();
                }
                return true;
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Format a bike for file storage.
     * 
     * @param bike The bike to format
     * @return The formatted string
     */
    private String formatBikeForFile(Bike bike) {
        return String.format("%d|%s|%s|%s|%.2f|%.2f|%s|%s",
                bike.getId(),
                bike.getName(),
                bike.getType(),
                bike.getDescription(),
                bike.getHourlyRate(),
                bike.getDailyRate(),
                bike.getStatus(),
                bike.getImageUrl());
    }
}
