local s,id=GetID()
function s.initial_effect(c)
local e0=Effect.CreateEffect(c)
e0:SetType(EFFECT_TYPE_ACTIVATE)
e0:SetCode(EVENT_FREE_CHAIN)
c:RegisterEffect(e0)
local e1=Effect.CreateEffect(c)
e1:SetCountLimit(1,id)
e1:SetRange(LOCATION_SZONE)
e1:SetType(EFFECT_TYPE_IGNITION)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetCategory(CATEGORY_CONTROL)
e1:SetDescription(aux.Stringid(id,0))
e1:SetCondition(s.steal_con)
e1:SetTarget(s.steal_tg)
e1:SetOperation(s.steal_op)
c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
e2:SetDescription(aux.Stringid(id,1))
e2:SetRange(LOCATION_SZONE)
e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
e2:SetCode(EFFECT_LPCOST_REPLACE)
e2:SetCondition(s.lp_con)
e2:SetOperation(s.lp_op)
c:RegisterEffect(e2)
end
s.listed_names={id}
s.listed_series={0x8e}
function s.steal_filter(c,e,atk)
return c:IsFaceup()and c:IsAttackBelow(atk)and c:IsCanBeEffectTarget(e)and c:IsAbleToChangeControler()
end
function s.high_vamp_atk(tp)
local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x8e)
if not g or #g<=0 then
return 0
end
local _,val=g:GetMaxGroup(Card.GetAttack)
return val
end
function s.steal_con(e,tp,eg,ep,ev,re,r,rp)
local atk=s.high_vamp_atk(tp)
return Duel.IsExistingMatchingCard(s.steal_filter,tp,0,LOCATION_MZONE,1,nil,e,atk)
end
function s.steal_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
local atk=s.high_vamp_atk(tp)
if chk==0 then
return Duel.IsExistingMatchingCard(s.steal_filter,tp,0,LOCATION_MZONE,1,nil,e,atk)
end
if chkc then
return chkc:IsAbleToChangeControler()
end
Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
local g=Duel.SelectTarget(tp,s.steal_filter,tp,0,LOCATION_MZONE,1,1,nil,e,atk)
Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,#g,0,0)
Duel.SetTargetCard(g)
end
function s.steal_op(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetTargetCards(e)
if not g or #g<=0 then
return
end
Duel.GetControl(g,e:GetHandlerPlayer(),PHASE_END,1)
end
function s.lp_filter(c)
return c:IsFaceup()and c:GetOwner()~=c:GetControler()
end
function s.lp_con(e,tp,eg,ep,ev,re,r,rp)
local rc=re:GetHandler()
return re and tp==ep and rc:IsSetCard(0x8e)
and Duel.IsExistingMatchingCard(s.lp_filter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.lp_op(e,tp,eg,ep,ev,re,r,rp)
local lp=ev/2
Duel.Damage(1-tp,lp,REASON_EFFECT)
Duel.Recover(tp,lp,REASON_EFFECT)
end
function s.lp_val(e,re,rp,val)
if not re then
return val
end
local tp=e:GetHandlerPlayer()
local rc=re:GetHandler()
if re and tp==rp and rc:IsSetCard(0x8e)
and Duel.IsExistingMatchingCard(s.lp_filter,tp,LOCATION_MZONE,0,1,nil)then
local lp=val/2
Duel.Damage(1-tp,lp,REASON_EFFECT)
Duel.Recover(tp,lp,REASON_EFFECT)
return 0
else
return val
end
end