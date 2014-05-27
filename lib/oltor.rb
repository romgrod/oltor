require "oltor/version"

require 'debugger'
require 'colorize'

module Oltor
class Load
	
	attr_reader :results
	attr_writer :url, :time, :max, 

	def initialize(url, max=nil)
		@time	= 10	
		@results = {}
		@client_groups = [5,10,20,30,40,50]
	end

	def execute clients
		raise "url not defined" if @url.nil?
		@results["#{clients}"]=`openload -l #{@time} #{@url} #{clients}`
	end

	def run

		@client_groups.each do |clients|
			break if clients > @max
			execute clients
		end	
		separator
	end

	def separator
		@total_tps 					= {}
		@avg_response_time 	= {}
		@max_response_time 	= {}
		@total_request 			= {}
		@total_errors 			= {}
		@results.each_pair do |group,result|
			group_results=result.split("\n")
			@total_tps["#{group}"] 					= group_results[0]
			@avg_response_time ["#{group}"] = group_results[1]
			@max_response_time ["#{group}"] = group_results[2]
			@total_request ["#{group}"] 		= group_results[3]
			@total_errors ["#{group}"] 			= group_results[4]
		end
	end

	def joined_report
		system('clear')
		puts "URL:#{@url}"
		puts "Time:#{@time}"
		print "Clients\t|  Total TPS\t|  AVG Response Time\t|  Max Response Time\t|  Total Requests\t|  Total Errors\n".colorize(:green)
		@client_groups.each do |group|
			break if group > @max
			clients=group.to_s
			print "  #{clients}\t|"
			print "     #{total_tps_value @total_tps[clients]}\t|"
			print "         #{total_tps_value @avg_response_time[clients]}    \t|"
			print "         #{max_response_time_value @max_response_time[clients]}    \t|"
			print "       #{total_request_value @total_request[clients]}         \t|"
			print "    #{total_errors_value @total_errors[clients]}    \n"
		end
		print_references
	end

	def separated_reports
		puts "\n"
		total_tps_report
		puts "\n"
		avg_response_time_report
		puts "\n"
		max_response_time_report
		puts "\n"
		total_request_report
		puts "\n"
		total_errors
		puts "\n"
		print_references
	end

	def print_references
		puts "\n"
		print "Total TPS:".colorize(:light_blue)
		print "  is the average TPS for the whole run, i.e. (Total completed requests) / (Total elapsed time).\n"
		print "AVG Response Time:".colorize(:light_blue)
		print "  The overall average response time in seconds.\n"
		print "Max Response Time:".colorize(:light_blue)
		print " The highest response time during this run.\n"
		print "Total Requests:".colorize(:light_blue)
		print " Total number of request.\n"
	end

	def total_tps_report
		puts "TOTAL TPS".colorize(:light_blue)
		puts "Clients\t| Value"
		@total_tps.each_pair do |group, string|
			number = total_tps_value string
			print "#{group}\t| #{number}\n"
		end
	end

	def total_tps_value(string)
		return "---" if string.nil?
		string.scan(/\d+\.\d+/).first.to_f
	end

	def avg_response_time_report
		puts "AVG RESPONSE TIME".colorize(:light_blue)
		puts "Clients\t|Value"
		@avg_response_time.each_pair do |group, string|
			number = avg_response_time_value string
			print "#{group}\t| #{number} (sec)\n"
		end
	end

	def avg_response_time_value string
		return "---" if string.nil?
		string.scan(/\d+\.\d+/).first.to_f
	end

	def max_response_time_report
		puts "Max Response Time".colorize(:light_blue)
		puts "Clients\t| Value"
		@max_response_time.each_pair do |group, string|
			number = max_response_time_value string
			print "#{group}\t| #{number}\n"
		end
	end

	def max_response_time_value string
		return "---" if string.nil?
		string.scan(/\d+\.\d+/).first.to_f
	end

	def total_request_report
		puts "TOTAL REQUESTS".colorize(:light_blue)
		puts "Clients\t| Value"
		@total_request.each_pair do |group, string|
			number = total_request_value string
			print "#{group}\t| #{number}\n"
		end
	end

	def total_request_value string
		return "---" if string.nil?
		string.scan(/\d+/).first
	end

	def total_errors
		puts "TOTAL ERRORS".colorize(:light_blue)
		puts "Clients\t| Value"
		@total_errors.each_pair do |group, string|
			number = total_errors_value string
			print "#{group}\t| #{number}\n"
		end
	end

	def total_errors_value string
		return "---" if string.nil?
		string.scan(/\d+/).first
	end

end




end
	
def load
	test = Oltor::Load.new
	yield test
	test.run
	my_test.joined_report
	my_test.separated_reports
end
