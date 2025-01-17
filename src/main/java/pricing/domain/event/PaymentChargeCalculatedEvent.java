package pricing.domain.event;

import events.IMessage;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import lcp.Lcp;
import money.Currency;
import money.Money;
import org.joda.time.DateTime;

public class PaymentChargeCalculatedEvent extends Event implements IMessage {

  public static final String NAME = "payment_charge_calculated";
  private UUID paymentId;
  private Money charges;
  private UUID merchantId;
  private DateTime occurredAt;
  private Integer version = 1;
  private Lcp lcp;

  public PaymentChargeCalculatedEvent(UUID paymentId, Money charges, UUID merchantId, Lcp lcp) {
    this.paymentId = paymentId;
    this.merchantId = merchantId;
    this.charges = charges;
    this.occurredAt = DateTime.now();
    this.lcp = lcp;
  }

  public UUID getPaymentId() {
    return paymentId;
  }

  public Money getCharges() {
    return charges;
  }

  public UUID getMerchantId() {
    return merchantId;
  }

  public Lcp getLcp() {
    return lcp;
  }

  public static PaymentChargeCalculatedEvent fromMessage(IMessage message) {
    if (!message.getName().matches(PaymentChargeCalculatedEvent.NAME)) {
      throw new RuntimeException();
    }
    Map<String, String> payload = message.getPayload();
    return new PaymentChargeCalculatedEvent(
        UUID.fromString(payload.get("id")),
        new Money(
            Integer.valueOf(payload.get("chargesAmount")),
            Currency.valueOf(payload.get("chargesCurrency"))
        ),
        UUID.fromString(payload.get("merchantId")),
        Lcp.valueOf(payload.get("lcp"))
    );
  }

  public Map<String, String> getPayload() {
    Map<String, String> payload = new HashMap<String, String>();
    payload.put("id", this.paymentId.toString());
    payload.put("chargesAmount", this.charges.getAmount().toString());
    payload.put("chargesCurrency", this.charges.getCurrency().toString());
    payload.put("merchantId", this.merchantId.toString());
    payload.put("lcp", this.getLcp().toString());
    return payload;
  }

  public String getName() {
    return NAME;
  }

  public DateTime getOccurredAt() {
    return this.occurredAt;
  }

  public Integer getVersion() {
    return this.version;
  }
}
