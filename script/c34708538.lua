local s,id=GetID()
function s.initial_effect(c)
c:EnableReviveLimit()
Link.AddProcedure(c,aux.FilterBoolFunctionEx(s.material_filter),1,1)
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(id,0))
e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
e1:SetCountLimit(1,id)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e1:SetCode(EVENT_SPSUMMON_SUCCESS)
e1:SetCondition(s.sp_con)
e1:SetCost(s.sp_cost)
e1:SetOperation(s.sp_op)
c:RegisterEffect(e1)
end
s.listed_names={id}
s.listed_series={0x8e}
function s.material_filter(c)
return c:IsFaceup()and(c:GetOwner()~=c:GetControler()or c:IsSetCard(0x8e))
end
function s.summon_filter(c,e)
return c:IsLevelBelow(2)and c:IsSetCard(0x8e)
and c:IsCanBeSpecialSummoned(e,0,e:GetHandlerPlayer(),false,false)
end
function s.sp_con(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
and Duel.IsExistingMatchingCard(s.summon_filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e)
end
function s.sp_cost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then
return Duel.CheckLPCost(tp,500)
end
Duel.PayLPCost(tp,500)
end
function s.sp_op(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
return
end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
local g=Duel.SelectMatchingCard(tp,s.summon_filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e)
Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
end