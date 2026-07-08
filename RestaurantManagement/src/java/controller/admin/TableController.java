package controller.admin;

import dao.DiningTableDAO;
import dao.RoomDAO;
import entity.DiningTable;
import entity.Room;
import enums.TableStatus;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "TableController", urlPatterns = {"/admin/tables"})
public class TableController extends HttpServlet {

    private DiningTableDAO tableDAO;
    private RoomDAO roomDAO;

    @Override
    public void init() throws ServletException {
        tableDAO = new DiningTableDAO();
        roomDAO = new RoomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // Handle language switch
        String lang = request.getParameter("lang");
        if (lang != null && (lang.equals("en") || lang.equals("vi"))) {
            request.getSession().setAttribute("lang", lang);
        }

        List<DiningTable> tables = tableDAO.ListAll();
        List<Room> rooms = roomDAO.ListAll();
        
        request.setAttribute("tables", tables);
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/admin/tables.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String lang = (String) request.getSession().getAttribute("lang");
        boolean isEn = "en".equals(lang);

        try {
            if ("add".equals(action)) {
                String tableCode = request.getParameter("tableCode");
                DiningTable existing = tableDAO.findByTableCode(tableCode);
                
                if (existing != null) {
                    if (!existing.getIsActive()) {
                        existing.setIsActive(true);
                        existing.setCapacity(Integer.parseInt(request.getParameter("capacity")));
                        existing.setBasePrice(new BigDecimal(request.getParameter("basePrice")));
                        existing.setImageUrl(trim(request.getParameter("imageUrl")));
                        existing.setStatus(TableStatus.valueOf(request.getParameter("status")));
                        
                        Integer roomId = Integer.parseInt(request.getParameter("roomId"));
                        Room room = roomDAO.searchById(roomId);
                        existing.setRoom(room);
                        
                        tableDAO.update(existing);
                        request.getSession().setAttribute("successMessage", isEn ? "Table restored successfully!" : "Khôi phục bàn thành công!");
                    } else {
                        throw new Exception("UNIQUE KEY"); // Trigger duplicate error handler
                    }
                } else {
                    DiningTable table = new DiningTable();
                    table.setTableCode(tableCode);
                    table.setCapacity(Integer.parseInt(request.getParameter("capacity")));
                    table.setBasePrice(new BigDecimal(request.getParameter("basePrice")));
                    table.setImageUrl(trim(request.getParameter("imageUrl")));
                    table.setStatus(TableStatus.valueOf(request.getParameter("status")));
                    
                    Integer roomId = Integer.parseInt(request.getParameter("roomId"));
                    Room room = roomDAO.searchById(roomId);
                    table.setRoom(room);
                    table.setIsActive(true);
                    
                    tableDAO.insert(table);
                    request.getSession().setAttribute("successMessage", isEn ? "Table added successfully!" : "Thêm bàn thành công!");
                }
                
            } else if ("update".equals(action)) {
                Integer id = Integer.parseInt(request.getParameter("id"));
                DiningTable table = tableDAO.searchById(id);
                
                if (table != null) {
                    table.setTableCode(request.getParameter("tableCode"));
                    table.setCapacity(Integer.parseInt(request.getParameter("capacity")));
                    table.setBasePrice(new BigDecimal(request.getParameter("basePrice")));
                    table.setImageUrl(trim(request.getParameter("imageUrl")));
                    table.setStatus(TableStatus.valueOf(request.getParameter("status")));
                    
                    Integer roomId = Integer.parseInt(request.getParameter("roomId"));
                    Room room = roomDAO.searchById(roomId);
                    table.setRoom(room);
                    
                    tableDAO.update(table);
                    request.getSession().setAttribute("successMessage", isEn ? "Table updated successfully!" : "Cập nhật bàn thành công!");
                }
                
            } else if ("delete".equals(action)) {
                Integer id = Integer.parseInt(request.getParameter("id"));
                DiningTable table = tableDAO.searchById(id);
                
                if (table != null) {
                    table.setIsActive(false); // Soft delete
                    tableDAO.update(table);
                    request.getSession().setAttribute("successMessage", isEn ? "Table hidden successfully!" : "Ẩn bàn thành công!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage();
            if (msg != null && msg.contains("UNIQUE KEY")) {
                request.getSession().setAttribute("errorMessage", isEn ? "Table code already exists. Please choose a different code." : "Mã bàn này đã tồn tại, vui lòng chọn mã khác!");
            } else {
                request.getSession().setAttribute("errorMessage", (isEn ? "An error occurred: " : "Có lỗi xảy ra: ") + msg);
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/tables");
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
