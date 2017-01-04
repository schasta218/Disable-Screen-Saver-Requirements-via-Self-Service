#!/bin/bash

####################################################################################################
#
# This script is in progress. The purpose of the script is to automate this entire workflow, so that 
# all the user needs to do is enter their JSS Credentials to begin. 
# 
####################################################################################################

jssurl=""
username=""
password=""

# This is the XML used to import the scripts into the JSS. The <script_contents_encoded> tag allows us to easily import the script.
DisableXML='<script><name>Disable&#32;ScreenSaver.sh</name><filename>DisableScreenSaver.sh</filename><category>Disable&#32;Screen&#32;Saver&#32;via&#32;Self&#32;Service</category><parameters><parameter4>JSS&#32;URL</parameter4><parameter5>Username</parameter5><parameter6>Password</parameter6></parameters><script_contents_encoded>IyEvYmluL2Jhc2gKCiMgQ2hlY2tpbmcgdG8gc2VlIGlmIHRoZSB1c2VyIGlzIHJ1bm5pbmcgS2V5bm90ZSBvciBQb3dlclBvaW50LiBJZiBub3QsIGl0IHdpbGwgc2VuZCB0aGVtIGEgbWVzc2FnZSBhbmQgbm90IHJ1biB0aGUgcmVzdCBvZiB0aGUgc2NyaXB0LgovYmluL3BzIC1heCB8IGdyZXAgIi9BcHBsaWNhdGlvbnMvTWljcm9zb2Z0IFBvd2VyUG9pbnQuYXBwL0NvbnRlbnRzL01hY09TL01pY3Jvc29mdCBQb3dlclBvaW50IiB8IGdyZXAgLXYgZ3JlcAppZiBbICQ/ICE9IDEgXQoJdGhlbgoJY29udGludWU9eWVzCmZpCi9iaW4vcHMgLWF4IHwgZ3JlcCAiL0FwcGxpY2F0aW9ucy9LZXlub3RlLmFwcC9Db250ZW50cy9NYWNPUy9LZXlub3RlIiB8IGdyZXAgLXYgZ3JlcAppZiBbICQ/ICE9IDEgXQoJdGhlbgoJY29udGludWU9eWVzCmZpCmlmIFsgIiRjb250aW51ZSIgIT0gInllcyIgXQoJdGhlbgoJc3VkbyBqYW1mIGRpc3BsYXlNZXNzYWdlIC1tZXNzYWdlICJQbGVhc2Ugb3BlbiBQb3dlclBvaW50IG9yIEtleW5vdGUgYmVmb3JlIHJ1bm5pbmciCmVsc2UKIyBNYWtpbmcgc3VyZSB0aGUgZm9sZGVyIHRoYXQgd2Ugd2lsbCBiZSBwdXR0aW5nIGZpbGVzIGluIGlzIGJvdGggZW1wdHksIGFuZCBjcmVhdGVkCnJtIC1yIC90bXAvanNzcHJvamVjdC8KbWtkaXIgL3RtcC9qc3Nwcm9qZWN0LwoKIyBUaGVzZSBhcmUgdGhlIHBhcmFtZXRlcnMgdGhhdCB3aWxsIGJlIHBhc3NlZCBpbnRvIHRoZSBzY3JpcHQuIEknbSBub3QgZXZlbiBhbGxvd2luZyB0aGUgdXNlciB0byBoYXJkY29kZSB0aGUgdmFsdWVzLCBzaW5jZSBJIGRvbid0IHdhbnQgdGhlIHVzZXIgcGFzc2luZyBzZW5zaXRpdmUgZGF0YSBpbnRvIGEgc2NyaXB0LiAKanNzdXJsPSQ0CnVzZXJuYW1lPSQ1CnBhc3N3b3JkPSQ2CgojIEdyYWJzIHRoZSBzZXJpYWwgbnVtYmVyIGZyb20gdGhlIGNvbXB1dGVyCnNlcmlhbF9udW1iZXI9YHN5c3RlbV9wcm9maWxlciBTUEhhcmR3YXJlRGF0YVR5cGUgfCBhd2sgJy9TZXJpYWwvIHtwcmludCAkNH0nYAoKIyBHZXRzIHRoZSBzZXJpYWwgbnVtYmVyIG9mIGFsbCB0aGUgZXhpc3RpbmcgY29tcHV0ZXJzIGluIHRoZSBFeGx1ZGUgU2NyZWVuIFNhdmVyIGNvbXB1dGVyIGdyb3VwLiBUaGlzIGVuc3VyZXMgdGhhdCB3aGVuIHdlIGFkZCB0aGUgbmV3IGNvbXB1dGVyIHRvIHRoZSBncm91cCwgd2UgYXJlIGFsc28gYWJsZSB0byBhZGQgYWxsIHRoZSBleGlzdGluZyBjb21wdXRlcnMuIAp2YXI9JChjdXJsIC1IICJBY2NlcHQ6IHR4dC94bWwiIC1zZmt1ICR7dXNlcm5hbWV9OiR7cGFzc3dvcmR9IGh0dHBzOi8vJHtqc3N1cmx9L0pTU1Jlc291cmNlL2NvbXB1dGVyZ3JvdXBzL2lkLzcgLVggR0VUIHwgeG1sbGludCAtLWZvcm1hdCAtIHwgZ3JlcCAnPHNlcmlhbF9udW1iZXI+JyB8IHNlZCAtbiAnc3w8c2VyaWFsX251bWJlcj5cKC4qXCk8L3NlcmlhbF9udW1iZXI+fFwxfHAnKQojIFBhc3NlcyBlYWNoIGluZGl2aWR1YWwgc2VyaWFsIG51bWJlciBpbnRvIGFuIGFycmF5LCBzbyB3ZSBjYW4gZ3JhYiB0aGVtIG9uZSBieSBvbmUgbGF0ZXIKZXhpc3Rpbmdfc2VyaWFscz0oJHZhcikKbG49JHsjZXhpc3Rpbmdfc2VyaWFsc1tAXX0KCiMgVGhpcyBnb2VzIHRocm91Z2ggZWFjaCBpdGVtIGluIHRoZSBhcnJheSBhbmQgYWRkcyB0aGUgYXBwcm9wcmlhdGUgWE1MIGFyb3VuZCBpdCBzbyB3ZSBjYW4gYWRkIHRoZSBjb21wdXRlciBpbiB0aHJvdWdoIHRoZSBBUEkuIEl0IHNhdmVzIGl0IGluIG11bHRpcGxlIHhtbCBmaWxlcy4Kbj0wCndoaWxlIFsgJG4gLWx0ICRsbiBdCmRvCgllY2hvICI8Y29tcHV0ZXI+Cgk8c2VyaWFsX251bWJlcj4ke2V4aXN0aW5nX3NlcmlhbHNbJG5dfTwvc2VyaWFsX251bWJlcj4KCTwvY29tcHV0ZXI+IiA+ICIvdG1wL2pzc3Byb2plY3QveG1sJHtufS54bWwiCgluPSQoKG4rMSkpCmRvbmUKCiMgQ29tYmluZXMgdGhlIHhtbCBmaWxlcyB0b2dldGhlcgpjYXQgL3RtcC9qc3Nwcm9qZWN0L3htbCogPj4gL3RtcC9qc3Nwcm9qZWN0L3BpZWNlMi54bWwKCiMgQWRkcyB0aGUgc2VyaWFsIG51bWJlciBvZiB0aGlzIGNvbXB1dGVyIGludG8gYW5vdGhlciB4bWwgZmlsZQplY2hvICI8Y29tcHV0ZXI+Cgk8c2VyaWFsX251bWJlcj4kc2VyaWFsX251bWJlcjwvc2VyaWFsX251bWJlcj4KCTwvY29tcHV0ZXI+IiA+ICIvdG1wL2pzc3Byb2plY3QvcGllY2UzLnhtbCIKCiMgQWRkcyB0aGUgb3RoZXIgcGllY2VzIG5lZWRlZCB0byBjb21wbGV0ZSB0aGUgZnVsbCB4bWwgZmlsZQplY2hvICI8P3htbCB2ZXJzaW9uPVwiMS4wXCIgZW5jb2Rpbmc9XCJVVEYtOFwiIHN0YW5kYWxvbmU9XCJub1wiPz4KPGNvbXB1dGVyX2dyb3VwPgoJPGNvbXB1dGVycz4iID4gIi90bXAvanNzcHJvamVjdC9waWVjZTEueG1sIgplY2hvICI8L2NvbXB1dGVycz4KPC9jb21wdXRlcl9ncm91cD4iID4gIi90bXAvanNzcHJvamVjdC9waWVjZTQueG1sIgoKIyBQdXRzIGFsbCB0aGUgcGllY2VzIHRvZ2V0aGVyIHRvIGNyZWF0ZSBhbiBYTUwgZmlsZSB0aGF0IGNhbiBmaW5hbGx5IGJlIGFkZGVkIHRocm91Z2ggdGhlIEFQSQpjYXQgL3RtcC9qc3Nwcm9qZWN0L3BpZWNlKiA+PiAvdG1wL2pzc3Byb2plY3QvYWRkX2NvbXB1dGVycy54bWwKCiMgQWRkcyB0aGUgY29tcHV0ZXJzIHRocm91Z2ggdGhlIEFQSQpjdXJsIC11ICR7dXNlcm5hbWV9OiR7cGFzc3dvcmR9IGh0dHBzOi8vJHtqc3N1cmx9L0pTU1Jlc291cmNlL2NvbXB1dGVyZ3JvdXBzL2lkLzcgLVQgL3RtcC9qc3Nwcm9qZWN0L2FkZF9jb21wdXRlcnMueG1sIC1YIFBVVAoKIyBDcmVhdGVzIGEgTGFuY2hEYWVtb24gdGhhdCB3aWxsIHJ1biBhIHNjcmlwdCBldmVyeSAxMCBzZWNvbmRzLiBUaGUgc2NyaXB0IHdpbGwgY2hlY2sgdG8gc2VlIGlmIFBvd2VyUG9pbnQgb3IgS2V5bm90ZSBpcyBzdGlsbCBydW5uaW5nLiBJZiBpdCBpcywgaXQgd2lsbCB0YWtlIHRoZSBjb21wdXRlciBvdXQgb2YgdGhlIEV4Y2x1ZGUgU2NyZWVuIFNhdmVyIGNvbXB1dGVyIGdyb3VwLCBhbmQgc3RvcCB0aGUgTGF1bmNoIERhZW1vbi4gVGhlIHNjcmlwdCB3YXMgZGVwbG95ZWQgdGhyb3VnaCB0aGUgSlNTIHdpdGggdGhpcyBzY3JpcHQuCmVjaG8gJzw/eG1sIHZlcnNpb249IjEuMCIgZW5jb2Rpbmc9IlVURi04Ij8+CjwhRE9DVFlQRSBwbGlzdCBQVUJMSUMgIi0vL0FwcGxlLy9EVEQgUExJU1QgMS4wLy9FTiIgImh0dHA6Ly93d3cuYXBwbGUuY29tL0RURHMvUHJvcGVydHlMaXN0LTEuMC5kdGQiPgo8cGxpc3QgdmVyc2lvbj0iMS4wIj4KPGRpY3Q+Cgk8a2V5PkxhYmVsPC9rZXk+Cgk8c3RyaW5nPmNvbS5qYW1mc29mdHdhcmUuc2NyZWVuc2F2ZXI8L3N0cmluZz4KCTxrZXk+UHJvZ3JhbUFyZ3VtZW50czwva2V5PgoJPGFycmF5PgoJCTxzdHJpbmc+c2g8L3N0cmluZz4KCQk8c3RyaW5nPi91c3IvbG9jYWwvamFtZi9iaW4vaXNydW5uaW5nLnNoPC9zdHJpbmc+Cgk8L2FycmF5PgoJPGtleT5SdW5BdExvYWQ8L2tleT4KCTx0cnVlLz4KCTxrZXk+U3RhcnRJbnRlcnZhbDwva2V5PgoJPGludGVnZXI+MTA8L2ludGVnZXI+CjwvZGljdD4KPC9wbGlzdD4nID4gL0xpYnJhcnkvTGF1bmNoRGFlbW9ucy9jb20uamFtZnNvZnR3YXJlLnNjcmVlbnNhdmVyLnBsaXN0CgplY2hvICc8P3htbCB2ZXJzaW9uPSIxLjAiIGVuY29kaW5nPSJVVEYtOCI/Pgo8IURPQ1RZUEUgcGxpc3QgUFVCTElDICItLy9BcHBsZS8vRFREIFBMSVNUIDEuMC8vRU4iICJodHRwOi8vd3d3LmFwcGxlLmNvbS9EVERzL1Byb3BlcnR5TGlzdC0xLjAuZHRkIj4KPHBsaXN0IHZlcnNpb249IjEuMCI+CjxkaWN0PgoJPGtleT5MYWJlbDwva2V5PgoJPHN0cmluZz5jb20uamFtZnNvZnR3YXJlLnNjcmVlbnNhdmVyb2ZmPC9zdHJpbmc+Cgk8a2V5PlByb2dyYW1Bcmd1bWVudHM8L2tleT4KCTxhcnJheT4KCQk8c3RyaW5nPnNoPC9zdHJpbmc+CgkJPHN0cmluZz4vdXNyL2xvY2FsL2phbWYvYmluL3NjcmVlbnNhdmVyb2ZmLnNoPC9zdHJpbmc+Cgk8L2FycmF5PgoJPGtleT5SdW5BdExvYWQ8L2tleT4KCTx0cnVlLz4KCTxrZXk+U3RhcnRJbnRlcnZhbDwva2V5PgoJPGludGVnZXI+MTA8L2ludGVnZXI+CjwvZGljdD4KPC9wbGlzdD4nID4gL0xpYnJhcnkvTGF1bmNoRGFlbW9ucy9jb20uamFtZnNvZnR3YXJlLnNjcmVlbnNhdmVyb2ZmLnBsaXN0CgpzbGVlcCA1CgpsYXVuY2hjdGwgbG9hZCAvTGlicmFyeS9MYXVuY2hEYWVtb25zL2NvbS5qYW1mc29mdHdhcmUuc2NyZWVuc2F2ZXIucGxpc3QKbGF1bmNoY3RsIGxvYWQgL0xpYnJhcnkvTGF1bmNoRGFlbW9ucy9jb20uamFtZnNvZnR3YXJlLnNjcmVlbnNhdmVyb2ZmLnBsaXN0CmZp</script_contents_encoded></script>'

ReEnableXML='<script><name>Re-Enable&#32;ScreenSaver</name><filename>ReEnableScreenSaver.sh</filename><category>Disable&#32;Screen&#32;Saver&#32;via&#32;Self&#32;Service</category><parameters><parameter4>JSS&#32;URL</parameter4><parameter5>Username</parameter5><parameter6>Password</parameter6></parameters><script_contents_encoded>IyEvYmluL2Jhc2gKIyBNYWtpbmcgc3VyZSB0aGUgZm9sZGVyIHRoYXQgd2Ugd2lsbCBiZSBwdXR0aW5nIGZpbGVzIGluIGlzIGJvdGggZW1wdHksIGFuZCBjcmVhdGVkCnJtIC1yIC90bXAvanNzcHJvamVjdC8KbWtkaXIgL3RtcC9qc3Nwcm9qZWN0LwoKIyBUaGVzZSBhcmUgdGhlIHBhcmFtZXRlcnMgdGhhdCB3aWxsIGJlIHBhc3NlZCBpbnRvIHRoZSBzY3JpcHQuIEknbSBub3QgZXZlbiBhbGxvd2luZyB0aGUgdXNlciB0byBoYXJkY29kZSB0aGUgdmFsdWVzLCBzaW5jZSBJIGRvbid0IHdhbnQgdGhlIHVzZXIgcGFzc2luZyBzZW5zaXRpdmUgZGF0YSBpbnRvIGEgc2NyaXB0LiAKanNzdXJsPSQ0CnVzZXJuYW1lPSQ1CnBhc3N3b3JkPSQ2CgojIEdyYWJzIHRoZSBzZXJpYWwgbnVtYmVyIGZyb20gdGhlIGNvbXB1dGVyCnNlcmlhbF9udW1iZXI9YHN5c3RlbV9wcm9maWxlciBTUEhhcmR3YXJlRGF0YVR5cGUgfCBhd2sgJy9TZXJpYWwvIHtwcmludCAkNH0nYAoKIyBHZXRzIHRoZSBzZXJpYWwgbnVtYmVyIG9mIGFsbCB0aGUgZXhpc3RpbmcgY29tcHV0ZXJzIGluIHRoZSBFeGx1ZGUgU2NyZWVuIFNhdmVyIGNvbXB1dGVyIGdyb3VwLiBUaGlzIGVuc3VyZXMgdGhhdCB3aGVuIHdlIGFkZCB0aGUgbmV3IGNvbXB1dGVyIHRvIHRoZSBncm91cCwgd2UgYXJlIGFsc28gYWJsZSB0byBhZGQgYWxsIHRoZSBleGlzdGluZyBjb21wdXRlcnMuIAp2YXI9JChjdXJsIC1IICJBY2NlcHQ6IHR4dC94bWwiIC1zZmt1ICR7dXNlcm5hbWV9OiR7cGFzc3dvcmR9IGh0dHBzOi8vJHtqc3N1cmx9L0pTU1Jlc291cmNlL2NvbXB1dGVyZ3JvdXBzL2lkLzcgLVggR0VUIHwgeG1sbGludCAtLWZvcm1hdCAtIHwgZ3JlcCAnPHNlcmlhbF9udW1iZXI+JyB8IHNlZCAtbiAnc3w8c2VyaWFsX251bWJlcj5cKC4qXCk8L3NlcmlhbF9udW1iZXI+fFwxfHAnKQojIFBhc3NlcyBlYWNoIGluZGl2aWR1YWwgc2VyaWFsIG51bWJlciBpbnRvIGFuIGFycmF5LCBzbyB3ZSBjYW4gZ3JhYiB0aGVtIG9uZSBieSBvbmUgbGF0ZXIKZXhpc3Rpbmdfc2VyaWFscz0oJHZhcikKbG49JHsjZXhpc3Rpbmdfc2VyaWFsc1tAXX0KCiMgVGhpcyBnb2VzIHRocm91Z2ggZWFjaCBpdGVtIGluIHRoZSBhcnJheSBhbmQgYWRkcyB0aGUgYXBwcm9wcmlhdGUgWE1MIGFyb3VuZCBpdCBzbyB3ZSBjYW4gYWRkIHRoZSBjb21wdXRlciBpbiB0aHJvdWdoIHRoZSBBUEkuIEl0IHNhdmVzIGl0IGluIG11bHRpcGxlIHhtbCBmaWxlcy4gSXQgYWxzbyBjaGVja3MgdG8gc2VlIGlmIHRoZSBzZXJpYWwgbnVtYmVyIGl0J3MgYWRkaW5nIG1hdGNoZXMgdGhlIHNlcmlhbCBudW1iZXIgb2YgdGhlIGNvbXB1dGVyLCBzaW5jZSB3ZSBET04nVCB3YW50IHRvIGFkZCB0aGF0IG9uZSB0byB0aGUgZ3JvdXAgKHdlIGFyZSBhY3R1YWxseSB0YWtpbmcgaXQgb3V0IHRoZSB0aGUgZ3JvdXApCm49MAp3aGlsZSBbICRuIC1sdCAkbG4gXQpkbwoJaWYgWyAke2V4aXN0aW5nX3NlcmlhbHNbJG5dfSAhPSAkc2VyaWFsX251bWJlciBdCgl0aGVuCgkJZWNobyAiPGNvbXB1dGVyPgoJCTxzZXJpYWxfbnVtYmVyPiR7ZXhpc3Rpbmdfc2VyaWFsc1skbl19PC9zZXJpYWxfbnVtYmVyPgoJCTwvY29tcHV0ZXI+IiA+ICIvdG1wL2pzc3Byb2plY3QveG1sJHtufS54bWwiCglmaQoJbj0kKChuKzEpKQpkb25lCgojIENvbWJpbmVzIHRoZSB4bWwgZmlsZXMgdG9nZXRoZXIKY2F0IC90bXAvanNzcHJvamVjdC94bWwqID4+IC90bXAvanNzcHJvamVjdC9waWVjZTIueG1sCgojIEFkZHMgdGhlIG90aGVyIHBpZWNlcyBuZWVkZWQgdG8gY29tcGxldGUgdGhlIGZ1bGwgeG1sIGZpbGUKZWNobyAiPD94bWwgdmVyc2lvbj1cIjEuMFwiIGVuY29kaW5nPVwiVVRGLThcIiBzdGFuZGFsb25lPVwibm9cIj8+Cjxjb21wdXRlcl9ncm91cD4KCTxjb21wdXRlcnM+IiA+ICIvdG1wL2pzc3Byb2plY3QvcGllY2UxLnhtbCIKZWNobyAiPC9jb21wdXRlcnM+CjwvY29tcHV0ZXJfZ3JvdXA+IiA+ICIvdG1wL2pzc3Byb2plY3QvcGllY2UzLnhtbCIKCiMgUHV0cyBhbGwgdGhlIHBpZWNlcyB0b2dldGhlciB0byBjcmVhdGUgYW4gWE1MIGZpbGUgdGhhdCBjYW4gZmluYWxseSBiZSBhZGRlZCB0aHJvdWdoIHRoZSBBUEkKY2F0IC90bXAvanNzcHJvamVjdC9waWVjZSogPj4gL3RtcC9qc3Nwcm9qZWN0L2FkZF9jb21wdXRlcnMueG1sCgojIEFkZHMgdGhlIGNvbXB1dGVycyB0aHJvdWdoIHRoZSBBUEkKY3VybCAtdSAke3VzZXJuYW1lfToke3Bhc3N3b3JkfSBodHRwczovLyR7anNzdXJsfS9KU1NSZXNvdXJjZS9jb21wdXRlcmdyb3Vwcy9pZC83IC1UIC90bXAvanNzcHJvamVjdC9hZGRfY29tcHV0ZXJzLnhtbCAtWCBQVVQKCiMgRG9lcyBzb21lIGJhc2ljIGNsZWFuIHVwCnJtIC1yIC90bXAvanNzcHJvamVjdC8KbGF1bmNoY3RsIHVubG9hZCAvTGlicmFyeS9MYXVuY2hEYWVtb25zL2NvbS5qYW1mc29mdHdhcmUuc2NyZWVuc2F2ZXIucGxpc3QKbGF1bmNoY3RsIHVubG9hZCAvTGlicmFyeS9MYXVuY2hEYWVtb25zL2NvbS5qYW1mc29mdHdhcmUuc2NyZWVuc2F2ZXJvZmYucGxpc3Q=</script_contents_encoded></script>'

## UPLOAD SCRIPTS ##

# Create a "Disable Screen Saver via Self Service" Category	
curl -H "Content-Type: application/xml" -u ${username}:${password} ${jssurl}/JSSResource/categories/id/0 -d "<category><name>Disable&#32;Screen&#32;Saver&#32;via&#32;Self&#32;Service</name></category>" -X POST

# Add the "Disable ScreenSaver" script through the API
curl -H "Content-Type: application/xml" -u ${username}:${password} ${jssurl}/JSSResource/scripts/id/0 -d $DisableXML -X POST

# Add the "ReEnable ScreenSaver" script through the API
curl -H "Content-Type: application/xml" -u ${username}:${password} ${jssurl}/JSSResource/scripts/id/0 -d $ReEnableXML -X POST

## NEXT STEPS ##

# Package isrunning.sh: You will need to package isrunning.sh so that it puts the script into /usr/local/jamf/bin/isrunning.sh. This location is important because we will be calling to it in our script. You can package this using Jamf Composer or another application. Once complete, upload the package to the JSS.

# Create JSS User: Create an JSS User that will be able to do only the processes that we need to do through the API. This user should have Read and Update privileges to Static Computer Groups.

# Create a Static Group: Create a static group named ExcludeScreenSaver.

# Create Configuration Profile: Create a configuration profile to force the screen saver to start after X minutes and lock the computer once the screen saver starts.

# Create the Disable Screen Saver Policy: Create a policy to disable the screen saver. 

# Create the ReEnable Screen Saver Policy: Create a policy to disable the screen saver.