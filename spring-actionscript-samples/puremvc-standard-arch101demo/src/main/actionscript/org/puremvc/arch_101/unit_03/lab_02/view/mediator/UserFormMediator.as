/*
  PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.view.mediator {
  import flash.events.Event;

  import org.puremvc.arch_101.unit_03.lab_02.ApplicationFacade;
  import org.puremvc.arch_101.unit_03.lab_02.ProxyNames;
  import org.puremvc.arch_101.unit_03.lab_02.model.IUserProxy;
  import org.puremvc.arch_101.unit_03.lab_02.model.enum.DeptEnum;
  import org.puremvc.arch_101.unit_03.lab_02.model.vo.UserVO;
  import org.puremvc.arch_101.unit_03.lab_02.view.component.UserForm;
  import org.puremvc.as3.interfaces.INotification;
  import org.springextensions.actionscript.puremvc.patterns.mediator.IocMediator;

  /**
   * Version: $Revision: 748 $, $Date: 2008-06-06 11:06:25 +0200 (vr, 06 jun 2008) $, $Author: dmurat1 $
   */
  public class UserFormMediator extends IocMediator {
//    public static const NAME:String = "userFormMediator";

    private var m_userProxy:IUserProxy;

    public function UserFormMediator(p_mediatorName:String = null, p_viewComponent:Object = null) {
      super(p_mediatorName, p_viewComponent);
      userForm.addEventListener(UserForm.ADD, onAdd);
      userForm.addEventListener(UserForm.UPDATE, onUpdate);
      userForm.addEventListener(UserForm.CANCEL, onCancel);

      m_userProxy = facade.retrieveProxy(ProxyNames.USER_PROXY) as IUserProxy;
    }

    private function get userForm():UserForm {
      return getViewComponent() as UserForm;
    }

    private function onAdd(p_event:Event):void {
      var user:UserVO = userForm.user;
      m_userProxy.addItem(user);
      sendNotification(ApplicationFacade.USER_ADDED, user);
      clearForm();
    }

    private function onUpdate(p_event:Event):void {
      var user:UserVO = userForm.user;
      m_userProxy.updateItem(user);
      sendNotification(ApplicationFacade.USER_UPDATED, user);
      clearForm();
    }

    private function onCancel(event:Event):void {
      sendNotification(ApplicationFacade.CANCEL_SELECTED);
      clearForm();
    }

    override public function listNotificationInterests():Array {
      return [ApplicationFacade.NEW_USER, ApplicationFacade.USER_DELETED, ApplicationFacade.USER_SELECTED];
    }

    override public function handleNotification(p_note:INotification):void {
      switch (p_note.getName()) {
        case ApplicationFacade.NEW_USER:
          userForm.user = p_note.getBody() as UserVO;
          userForm.mode = UserForm.MODE_ADD;
          userForm.first.setFocus();
          break;
        case ApplicationFacade.USER_DELETED:
          userForm.user = null;
          clearForm();
          break;
        case ApplicationFacade.USER_SELECTED:
          userForm.user = p_note.getBody() as UserVO;
          userForm.mode = UserForm.MODE_EDIT;
          userForm.first.setFocus();
          break;
      }
    }

    private function clearForm():void {
      userForm.user = null;
      userForm.username.text = "";
      userForm.first.text = "";
      userForm.last.text = "";
      userForm.email.text = "";
      userForm.password.text = "";
      userForm.confirm.text = "";
      userForm.department.selectedItem = DeptEnum.NONE_SELECTED;
    }
  }
}
