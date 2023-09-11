@istest
public class TestAssign3_1 {

    @istest
    public static void Testgo()
    {
        assign3_1_controller testa=new assign3_1_controller();
        PageReference p=testa.go();
        System.assert(p==null);
       testa.setS('USA');
        System.assert(testa.getS()!=null);
        System.assert(testa.s!=null);
        System.assert(testa.s1!=null);
        System.assert(testa.s2!=null);
    }
}