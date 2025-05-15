package dao;

import config.DatabaseConfig;
import model.Inquiry;

import java.io.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * File-based implementation of InquiryDAO.
 */
public class FileInquiryDAO implements InquiryDAO {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    @Override
    public List<Inquiry> getAllInquiries() {
        List<Inquiry> inquiries = new ArrayList<>();

        // Ensure the file exists
        DatabaseConfig.ensureFileExists(DatabaseConfig.INQUIRIES_FILE);

        try (BufferedReader reader = new BufferedReader(new FileReader(DatabaseConfig.INQUIRIES_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length == 8) {
                    Inquiry inquiry = new Inquiry(
                        Integer.parseInt(parts[0].trim()),
                        Integer.parseInt(parts[1].trim()),
                        parts[2],
                        parts[3],
                        parts[4],
                        parts[5],
                        LocalDateTime.parse(parts[6].trim(), DATE_FORMATTER),
                        parts[7]
                    );
                    inquiries.add(inquiry);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return inquiries;
    }

    @Override
    public Inquiry getInquiryById(int id) {
        try (BufferedReader reader = new BufferedReader(new FileReader(DatabaseConfig.INQUIRIES_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length == 8 && Integer.parseInt(parts[0].trim()) == id) {
                    return new Inquiry(
                        Integer.parseInt(parts[0].trim()),
                        Integer.parseInt(parts[1].trim()),
                        parts[2],
                        parts[3],
                        parts[4],
                        parts[5],
                        LocalDateTime.parse(parts[6].trim(), DATE_FORMATTER),
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
    public List<Inquiry> getInquiriesByUserId(int userId) {
        return getAllInquiries().stream()
                .filter(inquiry -> inquiry.getUserId() == userId)
                .collect(Collectors.toList());
    }

    @Override
    public boolean addInquiry(Inquiry inquiry) {
        List<Inquiry> inquiries = getAllInquiries();

        // Generate a new ID (get the highest ID and add 1)
        int newId = 1; // Default if no inquiries exist

        if (!inquiries.isEmpty()) {
            newId = inquiries.stream()
                    .mapToInt(Inquiry::getId)
                    .max()
                    .orElse(0) + 1;
        }

        inquiry.setId(newId);
        inquiries.add(inquiry);

        return saveAllInquiries(inquiries);
    }

    @Override
    public boolean updateInquiry(Inquiry inquiry) {
        List<Inquiry> inquiries = getAllInquiries();
        boolean updated = false;

        // Replace the inquiry with the updated one
        for (int i = 0; i < inquiries.size(); i++) {
            if (inquiries.get(i).getId() == inquiry.getId()) {
                inquiries.set(i, inquiry);
                updated = true;
                break;
            }
        }

        if (updated) {
            return saveAllInquiries(inquiries);
        }

        return false;
    }

    @Override
    public boolean deleteInquiry(int id) {
        List<Inquiry> inquiries = getAllInquiries();
        boolean removed = inquiries.removeIf(inquiry -> inquiry.getId() == id);

        if (removed) {
            return saveAllInquiries(inquiries);
        }

        return false;
    }

    /**
     * Save all inquiries to the file.
     *
     * @param inquiries The list of inquiries to save
     * @return true if the inquiries were saved successfully, false otherwise
     */
    private boolean saveAllInquiries(List<Inquiry> inquiries) {
        try {
            // Ensure directory exists
            DatabaseConfig.ensureFileExists(DatabaseConfig.INQUIRIES_FILE);

            // Write all inquiries to the file
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(DatabaseConfig.INQUIRIES_FILE))) {
                for (Inquiry inquiry : inquiries) {
                    writer.write(formatInquiryForFile(inquiry));
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
     * Format an inquiry for file storage.
     *
     * @param inquiry The inquiry to format
     * @return The formatted string
     */
    private String formatInquiryForFile(Inquiry inquiry) {
        // Use String.format without any extra spaces
        return String.format("%d|%d|%s|%s|%s|%s|%s|%s",
                inquiry.getId(),
                inquiry.getUserId(),
                inquiry.getUserName(),
                inquiry.getUserEmail(),
                inquiry.getSubject(),
                inquiry.getMessage(),
                inquiry.getInquiryTime().format(DATE_FORMATTER),
                inquiry.getStatus()).trim(); // Add trim to remove any potential extra spaces
    }
}
