console.log('htmlNode', htmlNode);
console.log('customProperties', customProperties);
console.log('data', data);
console.log('options', options);
console.log('theme', theme);

const getMetricByName = (metricName, noDataValue = 'No data') => {
    const filteredSeries = data.series.filter((series) => series.refId == metricName);
    if (filteredSeries.length > 0) {
        return filteredSeries[0].fields[1].values.buffer[0];
    }
    return noDataValue;
};
var total = getMetricByName('PaymentCleared');

const psc_text = htmlNode.getElementById('psc_text');
psc_text.textContent = total;
