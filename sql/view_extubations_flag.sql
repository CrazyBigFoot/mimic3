--Creating a flag by changes at the mechanical ventilation

CREATE OR REPLACE VIEW public.vw_extubations
AS SELECT i2.hadm_id,
    v.icustay_id,
    v.charttime,
    v.mechvent,
    v.oxygentherapy,
    v.extubated,
    v.selfextubated,
    v.mechvent - lag(v.mechvent, 1) OVER (ORDER BY v.icustay_id, v.charttime) AS ex
   FROM ventsettings v
     JOIN icustays i2 ON i2.icustay_id::numeric = v.icustay_id
  WHERE (v.mechvent + v.oxygentherapy + v.extubated + v.selfextubated) > 0 AND (i2.hadm_id IN ( SELECT hadm_overview.hadm_id
           FROM hadm_overview))
  ORDER BY v.icustay_id, v.charttime;
