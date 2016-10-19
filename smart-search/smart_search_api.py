# http://www.cibinmathew.com
# github.com/cibinmathew

import pyperclip
import pprint
import csv
import json
import sys
import time
sys.path.insert(0, r'C:\cbn\PYTHON')
from LIB import cbn, text_file_search,  cbn_debug, smart_functions
#sys.settrace(cbn_debug.debug_trace().trace_py)


command_help_dict = {
            'csv_cols' : { 'tooltip' : 'csv_cols  cols=1,2,3 text=clipboard',
                                    'default_fill' : 'text=clipboard quoting=csv.QUOTE_NONE',
                        'search_As_you_type' : {
                                                'cols' : [],
                                                 'quoting' : 'csv.QUOTE_NONE',
                                                'text' : ''
                                                
                                                }
                     },
            'cbn_grep' : { 'tooltip' : 'text=<command>',
                                    'default_fill' : '',
                        'search_As_you_type' : {
                                                'raw_search_term' : [],
                                                'sort_on_regex' : '',
                                                'location' : ['ahk', 'all', 'py', 'text']
                                                }
                     },
            'upper_case' : { 'tooltip' : 'text=<command>',
                                    'default_fill' : 'text=clipboard',
                        'search_As_you_type' : {
                                                'text' : ['ipconfig','ls','dir']
                                                }
                     },
            'cmd_subprocess' : { 'tooltip' : 'text=<command>',
                                    'default_fill' : '',
                        'search_As_you_type' : {
                                                'text' : ['ipconfig','ls','dir']
                                                }
                     },
            'pretty_print_json' : { 'tooltip' : 'string indent=4 sort_keys=True',
                                    'default_fill' : 'text=clipboard',
                                    'search_As_you_type' : {
                                                'indent' : [1,2,3,4,5,6,7,8],
                                                'text' : ['clipboard','selected_text'],
                                                'sort_keys' : ['True','False'],
                                                'quotes' : ['single','double'],
                                                'qa' : ['quarter end','quarter_beginning','yearly q'],
                                                'quotient' : ['quo','no q'],
                                                'quantum' : ['eidward','elvin','einstein','newton']
                                                }
                     },
            
                                               
            'decode_and_execute' : { 'tooltip' : 'delimiter=space|comma',
                        'search_As_you_type' : {}
                     }
            }
def get_keyword_match_as_you_type(options):
    # todo: change this
    print options
    sch_str = options['string']
    
    print sch_str
    import time
    import re
    #sch_str ='cmd ipconfig'
    #sch_str = string
    
    
    keyword_list = open(r'C:\cbn_gits\AHK\smart search\keywords.txt').read()
    #print "inside func get_keyword_match_as_you_type"

    output = text_file_search.search_in_csv(keyword_list,sch_str,[0,1],1)
    '''
    print text_file_search.sort_csv_on_regex_search(output,sch_str)
    file = open(options['output_filename'],'wb')
    file.write(text_file_search.sort_csv_on_regex_search(output,sch_str))
    file.close()
    '''
    #print text_file_search.sort_csv_on_regex_search(output,sch_str)
    return  output
    #text_file_search.sort_csv_on_regex_search(output,sch_str)
    
def tab_fill_next_suggestion(options): #command_name):
    #print options['text4']
    output_dict ={ 'un_selected_prefix' : options['text'], 'selection_text' : options['text2'],
    'un_selected_suffix' : options['text3'] ,
    'suggestions' : 'No suggestion',
    'first_desc' : 'default'    }
    #options['string'] = 'pretty_print_json'
    #print options['string']
    #print options['text']
    #print options['text2']
    # print options['text3']
    
    # time.sleep(5)
    #default_fill
    if options['string']== options['text'][:-1] and options['text4'] != 'backspace': # only the function name is typed, no arguments or anything else is typed
        if options['string'] in command_help_dict and 'default_fill' in command_help_dict[options['string']]:
            default_fill = command_help_dict[options['string']]['default_fill']
        else:
            default_fill = ''
        output_dict['un_selected_prefix'] = options['text'] + ' ' + default_fill  + ' '
    #suggestion_for_key or value
    #def get_next_arguments_of_commands(options): #command_name):
    import re
    search_term= [a for a in output_dict['un_selected_prefix'].split(' ')][-1].lower()
    this_suggestion = search_term + options['text2']
    # print 'this_suggestion: ' + this_suggestion
    # print 'search_term: ' + search_term
    try:
        help = command_help_dict[options['string']]['search_As_you_type']
        # print help
        output_dict['full_syntax'] = command_help_dict[options['string']]['tooltip']
 
        output=[]
        first_match=1
        #print 'asdf'.search('as')
        
        import copy
        already_typed_key_or_value = copy.copy(str(search_term[:] ))
        for key,value in help.iteritems():
            # print str(key) + '=' + r'.+'
            # print re.search(str(key) + '=' + r'.+', search_term,re.IGNORECASE)
            #print ' ' + str(key)+'='
            #if ' ' + str(key)+'=' in options['text']:
            
            #print search_term, 'key= ' +key
            # arguments already present
            if re.search(' -' + str(key) + ' ',output_dict['un_selected_prefix'], re.IGNORECASE) or re.search(' ' + str(key)+'=.+ ',output_dict['un_selected_prefix'], re.IGNORECASE):
                if not output_dict['un_selected_prefix'].endswith(key):
                    # print  ' : argument already present before'
                    continue
            
            # key is filled, waiting for the value        
            if search_term.endswith('='):
                suggestion_for_key = 0
                this_suggestion = options['text2'] or ''
                already_typed_key_or_value = ''
                arg = search_term[:-1]
                if arg==key:
                   
                    # print 'key : ' + search_term[:-1]
                    
                    # map will produce a list only if more than one element 
                    if isinstance(help[key],str):
                        all_values = [help[key]]
                    else:
                        all_values = help[key]
                    print all_values
                    output.extend(map(str,all_values))
                    break
            # key is filled, waiting for the value        
            elif search_term.lower().startswith('-' + str(key)):
                suggestion_for_key = 0
                arg = search_term[1:]
                #print 'key : ' + search_term[1:]        
                ouput.append( help[key])
                break
            #if key is typed and value is partially typed after the key
            elif re.search( str(key) + '=' + r'.+', search_term,re.IGNORECASE):
                suggestion_for_key = 0
                value_to_be_checked = search_term[(len(str(key))+1):]
                value_to_be_checked = search_term[(len(str(key))+1):]
                this_suggestion = search_term[(len(str(key))+1):] + options['text2']
                already_typed_key_or_value = copy.copy(value_to_be_checked)
               
                
                # print 'checking val : ' + value_to_be_checked
                #output.append(str(help[str(key)]))
                # print help[str(key)]
                for a in help[str(key)]:
                    if str(a).lower().startswith(value_to_be_checked):
                        # print a
                        # print type(a)
                        # print 'op= ' + str(output)
                        output.append(str(a))
               
                
            elif key.lower().startswith(search_term) :
                # print 'aaaaaaaa'
                suggestion_for_key = 1
                if search_term.lower().startswith('-'):
                    arg = search_term[1:]
                else:
                    arg = search_term
                # print arg
                if key.lower().startswith(arg):
                    if first_match:
                        #output.append( '=' + str(value) )
                        output_dict['first_desc'] = str(value)
                        first_match=0
                    output.append(key+ '=')
            else:
                pass
                # print 'NO MATCH'
            # print search_term
            # print str(key)
            # print 'already_typed_key_or_value loop end  ' , already_typed_key_or_value
        # print output
        if options['text4']=='tab':
            pass
            if not this_suggestion:
                # print output
                pass
            elif this_suggestion in output:
                n = output.index(this_suggestion)
                # print n, len(output)
                if n==len(output)-1:
                    n=-1
                # print 'n= ' + str(n)
                output = output[n+1:]
                # print output
            elif output[0].lower().startswith(this_suggestion):
                # print 'aaaaa'
                pass
                
        elif options['text4']=='backspace':
           
            output= []
            
        output_dict['suggestions'] = '\n'.join(output)
        if len(output):
            if output[0].endswith('='):
                key = output[0][:-1]
                # print key
            # print str(output[0])
            # print  'suggestion is key ' + str(suggestion_for_key)
            if suggestion_for_key:
                #print help[str(output[0])]
                output_dict['first_desc'] = str(help[str(key)]) or 'not available'
            else:
                output_dict['first_desc'] = 'no more value details available'
            #else:
            # print already_typed_key_or_value
            # print output[0] #[len(already_typed_key_or_value):]
            output_dict['selection_text'] = output[0][len(already_typed_key_or_value):]
            # print output_dict['selection_text']
                #output_dict['selection_text'] = output[0]
            output = '\n'.join(output)
            # print '\n\n' + output
            # print output_dict['selection_text']
        else:
            output_dict['selection_text'] = ''
        #except Exception,e:
            #print 'error: ' + str(e)
            help = 'no help found'
        
        
    except Exception,e:
        print 'error : ' + str(e)
        

    '''
    print json.dumps(output_dict)
    file = open(options['output_filename'],'wb')
    file.write(str(json.dumps(output_dict)))
    file.close()
    '''
    #time.sleep(5)
    print str(json.dumps(output_dict))
    return str(json.dumps(output_dict))

    '''        
    def get_arguments_of_commands(options): #command_name):
        
        try:                
            help = command_help_dict[options['string']]['tooltip']
        except:
            help = 'no help found'
        print help
        file = open(options['output_filename'],'wb')
        file.write(str(help))
        file.close()
        return # 'grep delimiter=space|comma'
    '''    

def decode_and_execute(options):
    """ddddddddd"""
    #def get_keyword_match(string):
    # todo: change this
    string = options['string']
    
    import time
    import re
    print options['text']
    reg = r'^' + options['string'] + r'\s*(.*)'
    func_name = options['string']
    
    reg = func_name + r'\s*'
    args = re.sub(reg , '', options['text'],re.M|re.I)
    
    print args
    kwargs = {}
    this_arg = ''
    
    for arg in args.split(' '):
        if this_arg!='':
            
            arg = this_arg + arg
        #print 'arg: ', arg
        match = re.search('(?P<key>.+)="(?P<value>.+)"', arg , re.IGNORECASE)
        if match:
            kwargs[str(match.group('key'))] = match.group('value')
            
            this_arg=''
            continue
        match = re.search('(?P<key>.+)="(?P<value>.+)', arg , re.IGNORECASE)
        if match: # partial argument, append this to next term    
            this_arg += arg
            
            continue
        match = re.search('(?P<key>.+)=(?P<value>.+)', arg , re.IGNORECASE)
        if match:
            kwargs[str(match.group('key'))] = match.group('value')
    #print kwargs
    for arg,value in kwargs.iteritems():
        if arg=='text':
            print value, 'texxxt'
            if value in ['clipboard']:
                print 'aaaa'
                text = cbn.get_clipboard()
            else:
                text = value
            print text.encode('utf-8').strip()
            kwargs['text'] = text
            print kwargs
        
    
    output_location = ''
    if options['string'] in command_help_dict and 'search_As_you_type' in command_help_dict[options['string']]:
        help = command_help_dict[options['string']]['search_As_you_type']
        if 'location' in kwargs and 'location' not in help.iterkeys():
           del kwargs['location']
            
        if 'text' in kwargs and 'text' not in help.iterkeys():
           del kwargs['text']
            
        if 'output' in kwargs:
            del kwargs['output']
            output_location = 'clipboard'
        else:
            output_location = ''
    #output = pretty_print_json(text,**kwargs)
    
    #output = smart_functions.
    #print globals()

    #print globals()['smart_functions'] #globals()  + func_name](text,**kwargs) #options, string)
    print 'aa ' ,func_name
    b = getattr(globals()['smart_functions'], func_name)
    #cbn.cbn_messagebox('tessst '+ repr(kwargs))
    print b
    output = b(**kwargs) #options, string)
    #cbn.cbn_messagebox(output) 
    if output_location =='clipboard':
        #cbn.set_clipboard(output)
        pyperclip.copy(str(output))
    print output

    return output
   
#print 'k'    
#for a in sys.argv:
#    print a
#time.sleep(3)
options ={}
#import datetime

#current_time=datetime.datetime.now()
    
if len(sys.argv) > 1:
    options['output_filename']= sys.argv[1]
    if len(sys.argv) > 2:
        options['func_name']= sys.argv[2]
    if len(sys.argv) > 3:
        options['string']= sys.argv[3]
    if len(sys.argv) > 4:
        options['text']= sys.argv[4]
    if len(sys.argv) > 5:
        options['text2']= sys.argv[5]
    if len(sys.argv) > 6:
        options['text3']= sys.argv[6]
    if len(sys.argv) > 7:
        options['text4']= sys.argv[7]
    #print options['text2']
    '''
    for n,a in enumerate(sys.argv):
        options.append(a)
    '''
else:  # script run without argument
    # options = [None, None, None, None, None]
    # string = str(cbn.get_clipboard())
    
    options['func_name']= 'tab_fill_next_suggestion'
    options['func_name']= 'get_keyword_match_as_you_type'
    options['func_name']= 'decode_and_execute'
    options['string']= 'upper_case'
    options['string']= ''
    options['text']= 'cbn_grep raw_search_term=django location=text'
    options['text']= 'csv_cols text=clipboard output=clipboard location=here '
    options['text']= 'cs co'
    options['text']= 'upper_case text=clipboard output=clipboard'
    options['text2']= ''
    options['text3']= ''
    options['text4']= ''
    options['output_filename']= 'output_filename.txt'
    
    if not options['string']:
        import re
        sch_str = 'cbn_grep raw'
        keyword_list = open(r'C:\cbn_gits\AHK\smart search\keywords.txt').read()
        # todo: not proper csv parsing
        for key in [line.split(',')[4] for line in keyword_list.splitlines()]:
            print '^' + str(key) + ' '
            if re.search(r'^' + str(key) + ' ',sch_str, re.IGNORECASE):
                options['string']=key
        #output = text_file_search.search_in_csv(keyword_list,sch_str,[0,1],1)
        #print output
        sys.exit()
output = locals()[options['func_name']](options)
file = open(options['output_filename'],'wb')
file.write(str(output))
file.close()
#time.sleep(4)
sys.exit(1)
if output:
    cbn.set_clipboard(output)
'''
a,b,c,d
1,2,3,4
w,x,y,z
'''

 