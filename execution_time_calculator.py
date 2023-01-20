
num_queries = 22
execution_time_array = [0] * num_queries

def parseAndGetExecutionTimeInSecond(result_string):
    parsed_string = result_string.split('=')
    return float(parsed_string[1])

with open('/home/TPCH-Greenplum/results1/results.log', 'r') as results1:
    with open('/home/TPCH-Greenplum/results2/results.log', 'r') as results2:
        with open('/home/TPCH-Greenplum/results3/results.log', 'r') as results3:
            for i in range(0, num_queries):
                result1_result = results1.readline()
                result2_result = results2.readline()
                result3_result = results3.readline()
                execution_time_array[i] += parseAndGetExecutionTimeInSecond(result1_result)
                execution_time_array[i] += parseAndGetExecutionTimeInSecond(result2_result)
                execution_time_array[i] += parseAndGetExecutionTimeInSecond(result3_result)
                execution_time_array[i] = round(execution_time_array[i] / 3, 2)
                
with open('./execution_average_result.txt', 'w') as result:
    execution_time_array = [str(time) for time in execution_time_array]
    result.write(','.join(execution_time_array))