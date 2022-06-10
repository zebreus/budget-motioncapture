#include <vector>
#include <string>
#include <map>
#include <iostream>
#include <xercesc/parsers/XercesDOMParser.hpp>
#include <xercesc/dom/DOM.hpp>
#include <xercesc/sax/HandlerBase.hpp>

using namespace std;
using namespace xercesc;

const std::string file = "/home/lennart/moca/out2.xml";

int main(){
	map<string,pair<int,int> > myData;
	
	// Initialize xerces
	try { XMLPlatformUtils::Initialize(); }
	catch (const XMLException& toCatch) {
	    char* message = XMLString::transcode(toCatch.getMessage());
	    cout << "Error during initialization! :\n"
	         << message << "\n";
	    XMLString::release(&message);
	        return 1;
	}
	
	XercesDOMParser* parser = new XercesDOMParser();
    parser->setValidationScheme(XercesDOMParser::Val_Always);
    parser->setDoNamespaces(true);
    parser->setDoSchema(true);
    parser->setValidationConstraintFatal(true);
    
// You'll probably need to change the string below, or you'll get a segmentation fault:
    parser->parse(XMLString::transcode("/home/lennart/moca/out2.xml"));
    
    DOMElement* docRootNode;
	DOMDocument* doc;
	doc = parser->getDocument();
	docRootNode = doc->getDocumentElement();
	DOMNodeIterator * walker;
	try {
	walker = doc->createNodeIterator(docRootNode,DOMNodeFilter::SHOW_ELEMENT,NULL,true);
	} catch (const xercesc_3_1::DOMException& e) {
		cout << XMLString::transcode(e.getMessage()) << " CODE: " << e.code << endl;
	}
	
	
	DOMNode * current_node = NULL;
	string thisNodeName;
	string parentNodeName;
	bool wordParts[3] = {false,false,false};
	string wordText = "";
	pair<int,int> wordTypeValue;
	
	//~ for (current_node = walker->nextNode(); current_node != 0; current_node = walker->nextNode()) {
		//~ thisNodeName = XMLString::transcode(current_node->getNodeName());
		//~ parentNodeName = XMLString::transcode(current_node->getParentNode()->getNodeName());
	//~ }

    
    cout << "out\n";
}
