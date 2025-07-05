package kr.co.solfood.payments.integrated;

import kr.co.solfood.user.cart.BillDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(rollbackFor = Exception.class)
public class IntegratedPaymentServiceImpl implements IntegratedPaymentService {
    
    @Autowired
    private IntegratedPaymentMapper integratedPaymentMapper;
    

    // PK 반환
    @Override
    public int createIntegratedPayment(BillDTO billDTO) {
        IntegratedPaymentVO integratedPayment = new IntegratedPaymentVO();
        integratedPayment.setStoreId(billDTO.getStoreId());
        integratedPayment.setIntegratedpaymentLeaderId((int) billDTO.getLeaderId());
        integratedPayment.setIntegratedpaymentAmount(billDTO.getTotalAmount());
        integratedPayment.setIntegratedpaymentPeople(billDTO.getUserBill().size());
        integratedPayment.setIntegratedpaymentStatus("pending");
        
        integratedPaymentMapper.insertIntegratedPayment(integratedPayment);
        return integratedPayment.getIntegratedpaymentId();
    }
    
    @Override
    public IntegratedPaymentVO getIntegratedPaymentById(int integratedPaymentId) {
        return integratedPaymentMapper.selectIntegratedPaymentById(integratedPaymentId);
    }
    
    @Override
    public IntegratedPaymentVO getIntegratedPaymentByLeaderId(long leaderId) {
        return integratedPaymentMapper.selectIntegratedPaymentByLeaderId(leaderId);
    }
} 