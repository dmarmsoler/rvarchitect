package org.tum.factum.pattern.generator

import org.tum.factum.pattern.pattern.CtaBinaryFormulas
import org.tum.factum.pattern.pattern.CtaFormula
import org.tum.factum.pattern.pattern.CtaPredicateCAct
import org.tum.factum.pattern.pattern.CtaPredicateConn
import org.tum.factum.pattern.pattern.CtaPredicateEq
import org.tum.factum.pattern.pattern.CtaPredicatePAct
import org.tum.factum.pattern.pattern.CtaPredicateVal
import org.tum.factum.pattern.pattern.CtaQuantifiedFormulas
import org.tum.factum.pattern.pattern.CtaUnaryFormulas
import org.tum.factum.pattern.pattern.Pattern

class IsabelleTextGenerator {
	
	def static toIsabelle(Pattern root) '''
	theory  «root.name»«"\n"»
	imports Auxiliary«"\n"»
	begin«"\n"»
	
	locale «root.psname» = «FOR ctyp : root.componentTypes»«"\n"»«"\t"»«ctyp.name»: dynamic_component «ctyp.ctsname»cmp «ctyp.ctsname»act «ENDFOR»+«"\n"»
	
	FIRST
«««	«root.componentTypes.get(0)»
	
	«"\t"»for 
	«FOR ctyp : root.componentTypes.drop(1)»
	«"\t"»«"\t"»and  «ctyp.ctsname»act :: "'«ctyp.ctsname»id \<Rightarrow> cnf \<Rightarrow> bool"
	«"\t"»«"\t"»and  «ctyp.ctsname»cmp :: "'«ctyp.ctsname»id \<Rightarrow> cnf \<Rightarrow> '«ctyp.ctsname»"«ENDFOR» + «"\n"»
	
	«"\t"»fixes «FOR a : Auxiliary.getInputPorts(root)»
	«FOR ctyp : root.componentTypes»«"\t"»«"\t"»and «ctyp.ctsname»«a.map[name].toString.replaceAll("[\\[\\],]","")» :: '«ctyp.ctsname» \<Rightarrow>  «a.map[it.inputPrtSrtTyp.name].toString.replaceAll("[\\[\\],]","")» set«"\n"»
	«ENDFOR»
	«ENDFOR»
	«FOR b : Auxiliary.getOutputPorts(root)»
	«FOR ctyp : root.componentTypes»«"\t"»«"\t"»and «ctyp.ctsname»«b.map[name].toString.replaceAll("[\\[\\],]","")» :: '«ctyp.ctsname» \<Rightarrow>  «b.map[it.outputPrtSrtTyp.name].toString.replaceAll("[\\[\\],]","")»
	«ENDFOR»
	«ENDFOR»
	
««« assumption begins (if not null)
	«"\t"»assumes 
	
	«FOR cta : root.ctaFormulaIds»«cta.name»: “\<lbrakk>t\<in>arch\<rbrakk> \<Longrightarrow> 
		«val ctaElement = root.ctaFormulaIds.filter[v|v.name == cta.name]»
		«FOR uf : ctaElement»
			«mapFormula(uf.ctaFormula)»
		«ENDFOR»
	«ENDFOR»
	
	
	begin «"\n"»
	
	...«"\n"»
	
	end
	'''
	
	def static mapFormula(CtaFormula ctaFormula){
		return '''
			«IF ctaFormula.ctaUnaryFormulas !== null»«generateFormula(ctaFormula.ctaUnaryFormulas)»«ENDIF»
			«IF ctaFormula.ctaQuantifiedFormulas !== null»«generateFormula(ctaFormula.ctaQuantifiedFormulas)»«ENDIF»
			«IF ctaFormula.ctaPredicateCAct !== null»«generateFormula(ctaFormula.ctaPredicateCAct)»«ENDIF»
			«IF ctaFormula.ctaPredicatePAct !== null»«generateFormula(ctaFormula.ctaPredicatePAct)»«ENDIF»
			«IF ctaFormula.ctaPredicateConn !== null»«generateFormula(ctaFormula.ctaPredicateConn)»«ENDIF»
			«IF ctaFormula.ctaPredicateVal !== null»«generateFormula(ctaFormula.ctaPredicateVal)»«ENDIF»
			«IF ctaFormula.ctaPredicateEq !== null»«generateFormula(ctaFormula.ctaPredicateEq)»«ENDIF»
			«IF ctaFormula.ctaBinaryFormulas !== null»«generateFormula(ctaFormula.ctaBinaryFormulas)»«ENDIF»
		'''
	}
	
	def dispatch static generateFormula(CtaUnaryFormulas ctau)
		'''(\«IF ctau.unaryOperator.ltlG == 'G'»<box> «ENDIF»«IF ctau.unaryOperator.ltlF == 'F'»<diamond> «ENDIF»«IF ctau.unaryOperator.ltlF == 'X'»<circle> «ENDIF»
		«mapFormula(ctau.ctaFormulaLtl)»
		\<^sub>c '''
		
		
	def dispatch static generateFormula(CtaQuantifiedFormulas ctaq)
		'''«IF ctaq.quantifierOperator.exists == '∃'»\<exists>\<^sup>c «ctaq.quantifierOperator.quantifiedExistsVar.name».«ENDIF»«IF ctaq.quantifierOperator.all == '∀'»\<all>\<^sup>c «ctaq.quantifierOperator.quantifiedAllVar.name».«ENDIF»'''
	def dispatch static generateFormula(CtaPredicateCAct ctapc)
		'''(\«IF ctapc.CAct == 'cAct'»(ca (\<lambda>c. «ctapc.CActCmpVar.cmptypAssigned.ctsname»active «ctapc.CActCmpVar.name» c)«ENDIF»'''
	def dispatch static generateFormula(CtaPredicatePAct ctapp)
		'''(\«IF ctapp.PAct== 'pAct'»(ca (\<lambda>c. «ctapp.PActCtaCmpVaref.cmpRef.cmptypAssigned.ctsname»active «ctapp.PActCtaCmpVaref.cmpRef.name» c)«ENDIF»'''
	def dispatch static generateFormula(CtaPredicateConn ctaconn){
		val connCmpTypShortName1 = ctaconn.ctaConnCmpVarInptPort.inptPrtCmpRef.cmptypAssigned.ctsname
		val connCmpTypShortName2 = ctaconn.ctaConnCmpVarOutputPort.outptPrtCmpRef.cmptypAssigned.ctsname
		
		val connCmpVarInputPort = ctaconn.ctaConnCmpVarInptPort.inputPrtrf.name
		val connCmpVarOutputPort = ctaconn.ctaConnCmpVarOutputPort.outputPrtrf.name
		
		val connCmpVar1 = ctaconn.ctaConnCmpVarInptPort.inptPrtCmpRef.name
		val connCmpVar2 = ctaconn.ctaConnCmpVarOutputPort.outptPrtCmpRef.name
		
	'''(\«IF ctaconn.ctaConn == 'conn'»(ca (\<lambda>c. «connCmpTypShortName2»«connCmpVarOutputPort» («connCmpTypShortName2»cmp «connCmpVar2» c) \in «connCmpTypShortName1»«connCmpVarInputPort» («connCmpTypShortName1»cmp «connCmpVar1» c)))«ENDIF»'''
	}
	
	def dispatch static generateFormula(CtaPredicateVal ctapval) {
		//val valCmpVarInputPort = ctape.valCtaCmpVaref.prtrf.inputPort.name //or change this to generic 'prtrf' and let it be spefied by the user
		val valCmpVarInputPort = ctapval.valCmpVariableRef.portRef.name 
		
		val valCmpTypShortName = ctapval.valCmpVariableRef.cmpRef.cmptypAssigned.ctsname
		val valCmpVar = ctapval.valCmpVariableRef.cmpRef.name
		val valOps = ctapval.ctaValTerms.termOperatorFunction.trmOperator.name
		val valOpsInput = ctapval.ctaValTerms.termOperatorFunction.trmOperands.map[terms.name].toString.replaceAll("[\\[\\],]]","")
		//val valOpsInput = ctapval.ctaValTerms.termOperatorFunction.trmOperands.map[terms.termsDtVar.name]
		
		
		'''(\«IF ctapval.ctaVal == 'val'» (ca (\<lambda>c. «valOps» «valOpsInput» = «valCmpTypShortName»«valCmpVarInputPort» («valCmpTypShortName» «valCmpVar» c) «ENDIF»\<^sub>c'''
		}
	def dispatch static generateFormula(CtaPredicateEq ctapeq){
		'''	(\ (ca (\<lambda>c.  «ctapeq.ctaComponentVariable1.name» = «ctapeq.ctaComponentVariable2.name» ) \<^sub>c'''
	}
	
	def dispatch static generateFormula(CtaBinaryFormulas ctabf){
//		'''	generateFormulaBinary(\«IF ctabf.binaryOperator.map[lImplies]» x «ENDIF»\<^sub>c'''
		return '''
«««		generateFormulaBinary
«««		«ctabf.binaryOperator.map[LAnd]»
«««		«ctabf.binaryOperator.map[LImplies]»
«««		«ctabf.ctaFormulaLgk»
		«FOR idx : 0..ctabf.binaryOperator.length-1»
			«val value = ctabf.binaryOperator.get(idx)»
			«IF value.LImplies !== null»«IF idx==0»«mapFormula(ctabf.ctaFormulaLgk.get(idx))»«ENDIF»\<longrightarrow>\<^sup>c «mapFormula(ctabf.ctaFormulaLgk.get(idx+1))»«ENDIF»
			«IF value.LAnd !== null»«IF idx==0»«mapFormula(ctabf.ctaFormulaLgk.get(idx))»«ENDIF» \<and>\<^sup>c «mapFormula(ctabf.ctaFormulaLgk.get(idx+1))»«ENDIF»
			«IF value.LDisjunct !== null»«IF idx==0»«mapFormula(ctabf.ctaFormulaLgk.get(idx))»«ENDIF»  \<or>\<^sup>c «mapFormula(ctabf.ctaFormulaLgk.get(idx+1))»«ENDIF»
			«IF value.LDoubleImplies !== null»«IF idx==0»«mapFormula(ctabf.ctaFormulaLgk.get(idx))»«ENDIF» \<longrightarrow>\<^sup>c «mapFormula(ctabf.ctaFormulaLgk.get(idx+1))»«ENDIF»
			«IF value.LWeakUntil !== null»«IF idx==0»«mapFormula(ctabf.ctaFormulaLgk.get(idx))»«ENDIF» \<WW>\<^sup>c «mapFormula(ctabf.ctaFormulaLgk.get(idx+1))»«ENDIF»
			«IF value.LUntil !== null»«IF idx==0»«mapFormula(ctabf.ctaFormulaLgk.get(idx))» «ENDIF»\<UU>\<^sup>c «mapFormula(ctabf.ctaFormulaLgk.get(idx+1))»«ENDIF»
		«ENDFOR»
		'''
	}
}




/*
 * 
theory Publisher_Subscriber
imports Singleton
begin

locale publisher_subscriber =
  publisher: singleton pbactive pbcmp +
  subscriber: dynamic_component sbcmp sbactive
    
    for pbactive :: "'pid \<Rightarrow> cnf \<Rightarrow> bool"
    and pbcmp :: "'pid \<Rightarrow> cnf \<Rightarrow> 'PB"
    and sbactive :: "'sid \<Rightarrow> cnf \<Rightarrow> bool"
    and sbcmp :: "'sid \<Rightarrow> cnf \<Rightarrow> 'SB" +
  
  fixes pbIn :: "'PB \<Rightarrow> bool set"
    and pbOut :: "'PB \<Rightarrow> int set"
    and sbIn :: "'SB \<Rightarrow> bool set"
    and sbOut :: "'SB \<Rightarrow> int set"
begin

...

end
  
end
 */
 