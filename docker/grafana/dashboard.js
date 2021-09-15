const psc_count = htmlNode.getElementById('psc_count');
const payment_cleared_count = htmlNode.getElementById('payment_cleared_count');
const payment_cleared_topic = htmlNode.getElementById('payment_cleared_topic');
const payment_priced_topic = htmlNode.getElementById('payment_priced_topic');
const payment_priced_count = htmlNode.getElementById('payment_priced_count');
const pricing_failed_count = htmlNode.getElementById('pricing_failed_count');
const pricing_failed_topic = htmlNode.getElementById('pricing_failed_topic');

const getMetricByName = (metricName, noDataValue = 'No data') => {
    const filteredSeries = data.series.filter((series) => series.refId == metricName);
    if (filteredSeries.length > 0) {
        return filteredSeries[0].fields[1].values.buffer[1];
    }
    return noDataValue;
};

var psc_total = getMetricByName('psc_count');
var payment_cleared_total  = getMetricByName('payment_cleared');
var priced_total  = getMetricByName('payment_priced');
var pricing_failed_total  = getMetricByName('payment_pricing_failed');
var pricing_total = priced_total + pricing_failed_total;

if (payment_cleared_total!=psc_total) {
    payment_cleared_topic.style.fill = "#f79740";
} else {
    payment_cleared_topic.style.fill = "#72d372";
}

if (pricing_total!=payment_cleared_total) {
    payment_priced_topic.style.fill = "#f79740";
    pricing_failed_topic.style.fill = "#f79740";

} else {
    payment_priced_topic.style.fill = "#72d372";
    pricing_failed_topic.style.fill = "#72d372";
}

psc_count.textContent = psc_total;
payment_cleared_count.textContent = payment_cleared_total;
payment_priced_count.textContent = priced_total;
pricing_failed_count.textContent = pricing_failed_total;