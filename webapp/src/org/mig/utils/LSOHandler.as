package org.mig.utils {
    import flash.net.SharedObject;

    public class LSOHandler {

        private var mySO:SharedObject;
        private var lsoType:String;

        // The parameter is "feeds" or "sites".
        public function LSOHandler(s:String) {
            init(s);
        }

        private function init(s:String):void
        {
            lsoType = s;
            mySO = SharedObject.getLocal(lsoType);
        }

        public function getObject():Object {
            return mySO.data[lsoType];
        }

        public function addObject(o:Object):void {
            mySO.data[lsoType] = o;
            mySO.flush();
        }

    }

}
