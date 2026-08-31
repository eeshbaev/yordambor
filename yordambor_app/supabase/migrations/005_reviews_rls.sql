-- Review insert policy for kelishuv participants after completion

create policy "reviews_insert_participant" on reviews for insert
  with check (
    auth.uid() = reviewer_id
    and exists (
      select 1 from kelishuvlar k
      where k.id = kelishuv_id
        and k.status = 'bajarildi'
        and (k.party_a_id = auth.uid() or k.party_b_id = auth.uid())
    )
  );

create policy "reviews_update_provider_reply" on reviews for update
  using (
    exists (
      select 1 from xizmatlar x
      where x.id = reviews.xizmat_id
        and x.owner_id = auth.uid()
    )
  );
